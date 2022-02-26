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
    struct Ping: ParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "ping",
            abstract: "Runs a quick ping test"
        )
        
        @Option(help: "The host to ping")
        var host: String?
        
        func run() throws {
            try options.load()
            
            let host = host ?? Configuration.shared.sources.ping
            Log.message(Log.Icon.internet, "Starting ping test...")
            Shell.run("ping \(host)")
            Log.done()
        }
    }
}
