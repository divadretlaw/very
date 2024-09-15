//
//  Setup.swift
//  very
//
//  Created by David Walter on 20.03.21.
//

import ArgumentParser
import Foundation
import Shell

extension Very {
    struct Setup: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static let configuration = CommandConfiguration(
            commandName: "setup",
            abstract: "Makes an initial setup on this machine"
        )
        
        func run() async throws {
            let configuration = try await options.load()
            let commands = SetupCommands(configuration: configuration)
            
            guard let setup = configuration.setup else {
                Log.error("No setup configuration found")
                return
            }
            
            try await commands.tap(repositories: setup.taps)
            
            try await commands.open(setup.open)
            
            try await commands.install(packages: setup.packages)
            try await commands.install(casks: setup.casks)
            
            for additional in setup.additional {
                Log.message(Log.Icon.info, additional.comment)
                let script = Script(additional.command)
                try await script()
            }
        }
    }
}
