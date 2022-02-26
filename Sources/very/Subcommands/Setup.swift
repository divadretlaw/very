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
    struct Setup: ParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "setup",
            abstract: "Makes an initial setup on this machine"
        )
        
        func run() throws {
            try options.load()
            
            guard let setup = Configuration.shared.setup else {
                Log.error("No setup configuration found")
                return
            }
            
            SetupCommands.tap(repositories: setup.taps)
            
            SetupCommands.open(setup.open)
            
            SetupCommands.install(packages: setup.packages)
            SetupCommands.install(casks: setup.casks)
            
            setup.additional.forEach { additional in
                Log.message(Log.Icon.info, additional.comment)
                Shell.run(additional.command)
            }
        }
    }
}
