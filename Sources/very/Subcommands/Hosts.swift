//
//  Hosts.swift
//  very
//
//  Created by David Walter on 26.08.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Hosts: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static let configuration = CommandConfiguration(
            commandName: "hosts",
            abstract: "Updates '/etc/hosts'"
        )
        
        func run() async throws {
            let configuration = try await options.load()
            
            guard let hosts = configuration.sources.hosts else {
                Log.error("Hosts configuration missing.")
                return
            }
            
            let url = hosts.source
            
            if hosts.sudo, ProcessInfo.processInfo.userName != "root" {
                try await Very.sudo()
                return
            }
            
            Log.message(Log.Icon.notes, "Updating \(Log.path(hosts.target)) from \(Log.url(hosts.source))...")
            
            do {
                let (data, response) = try await Very.urlSession.data(from: url)
                
                guard response.isSuccess, let text = String(data: data, encoding: .utf8) else {
                    return
                }
                
                var file = "# Last updated: \(Date())"
                
                if hosts.defaults {
                    let defaults = """
                \n
                127.0.0.1 localhost
                ::1 localhost
                255.255.255.255 broadcasthost
                127.0.0.1 127.0.0.1
                \n
                """
                    file.append(defaults)
                }
                
                let filtered = text
                    .split(separator: "\n")
                    .filter { !$0.starts(with: "#") && $0.contains("0.0.0.0") }
                    .joined(separator: "\n")
                
                file.append(filtered)
                try file.write(toFile: hosts.target, atomically: true, encoding: .ascii)
                Log.done()
            } catch {
                Log.error(error)
            }
        }
    }
}
