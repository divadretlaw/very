//
//  Update.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Update: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "update",
            abstract: "Checks for package updates and installs them"
        )
        
        @Flag(help: "Checks for system updates and installs them.")
        var system = false
        
        @Flag(help: "Checks for package and system updates and install them.")
        var much = false
        
        func run() async throws {
            let configuration = try await options.load()
            let commands = UpdateCommands(configuration: configuration)
            
            if much {
                commands.all()
            } else if system {
                commands.system()
            } else {
                commands.default()
            }
        }
    }
}
