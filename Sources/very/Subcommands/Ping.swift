//
//  Ping.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import ArgumentParser
import Foundation
import Shell

extension Very {
    struct Ping: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "ping",
            abstract: "Runs a quick ping test"
        )
        
        @Option(help: "The host to ping")
        var host: String?
        
        func run() async throws {
            let configuration = try await options.load()
            
            let host = host ?? configuration.sources.ping
            Log.message(Log.Icon.internet, "Starting ping test...")
            Shell.run("ping \(host)")
            Log.done()
        }
    }
}
