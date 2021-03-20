//
//  Setup.swift
//  very
//
//  Created by David Walter on 20.03.21.
//

import Foundation
import SwiftCLI
import Shell

extension Very {
    class Setup: Command {
        let name = "setup"
        let shortDescription = "Makes an initial setup on this computer"
        
        func execute() throws {
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
                shell(additional.command)
            }
        }
    }
}
