//
//  Update.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Update: ParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "update",
            abstract: "Checks for package updates and installs them"
        )
        
        @Flag(help: "Checks for system updates and installs them.")
        var system = false
        
        @Flag(help: "Checks for package and system updates and install them.")
        var much = false
        
        func run() throws {
            try options.load()
            
            if much {
                UpdateCommands.all()
            } else if system {
                UpdateCommands.system()
            } else {
                UpdateCommands.default()
            }
        }
    }
}
