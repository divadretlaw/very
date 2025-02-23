//
//  IP.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import ArgumentParser

extension Very {
    struct IP: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static let configuration = CommandConfiguration(
            commandName: "ip",
            abstract: "Prints your global IP address"
        )
        
        // MARK: - AsyncParsableCommand
        
        func run() async throws {
            let configuration = try await options.load()
            
            guard let url = configuration.sources.ip else {
                Log.error("Invalid URL")
                return
            }
            
            do {
                let (data, response) = try await Very.urlSession.data(from: url)
                
                guard response.isSuccess, let text = String(data: data, encoding: .utf8) else {
                    Log.error("Unable to fetch data.")
                    return
                }
                
                Log.message(text)
            } catch {
                Log.error(error)
            }
        }
    }
}
