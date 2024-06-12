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
        
        static var configuration = CommandConfiguration(
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
            
            commands.tap(repositories: setup.taps)
            
            commands.open(setup.open)
            
            commands.install(packages: setup.packages)
            commands.install(casks: setup.casks)
            
            for additional in setup.additional {
                Log.message(Log.Icon.info, additional.comment)
                Shell.run(additional.command)
            }
        }
    }
}
