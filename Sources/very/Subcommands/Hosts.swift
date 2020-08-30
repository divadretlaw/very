//
//  Hosts.swift
//  very
//
//  Created by David Walter on 26.08.20.
//

import Foundation
import SwiftCLI

extension Very {
    class Hosts: Command {
        let name = "hosts"
        let shortDescription = "Updates '/etc/hosts'"
        
        func execute() throws {
            guard let hosts = Configuration.shared.sources.hosts else {
                Log.error("Hosts configuration missing.")
                return
            }
            
            let url = hosts.source
            
            if hosts.sudo, ProcessInfo.processInfo.userName != "root" {
                Very.sudo()
                return
            }
            
            Log.message("📝", "Updating \(Log.path(hosts.target)) from \(Log.url(hosts.source))...")
            
            let (rawData, response, error) = URLSession.shared.synchronousDataTask(with: url)
            
            guard response.isSuccess, let data = rawData, let text = String(data: data, encoding: .utf8) else {
                Log.error(error)
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
            
            do {
                try file.write(toFile: hosts.target, atomically: true, encoding: .ascii)
                Log.done()
            } catch {
                Log.error(error)
            }
        }
    }
}
