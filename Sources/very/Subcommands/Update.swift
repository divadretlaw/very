//
//  File.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import Foundation
import SwiftCLI

extension Very {
    class Update: Command {
        let name = "update"
        let shortDescription = "Checks for updates and installs them"
        
        @Flag("--system", description: "Checks for system updates and installs them.")
        var system: Bool
        
        @Flag("--much", description: "Checks for package and system updates and install them.")
        var much: Bool
        
        func execute() throws {
            if self.much {
                UpdateCommands.all()
            } else if self.system {
                UpdateCommands.system()
            } else {
                UpdateCommands.default()
            }
        }
    }
}
