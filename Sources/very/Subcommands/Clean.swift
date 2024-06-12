//
//  Clean.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Clean: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "clean",
            abstract: "Cleans the system"
        )
        
        @Flag(help: "Runs additional clean commands.")
        var additional = false
        
        @Flag(help: "Removes contents of directories.")
        var directories = false
        
        @Flag(help: "Empties the trash.")
        var trash = false
        
        @Flag(help: "Runs all clean commands.")
        var wow = false
        
        func run() async throws {
            let configuration = try await options.load()
            let cleanCommands = CleanCommands(configuration: configuration)
            let diskCommands = DiskCommands(configuration: configuration)
            
            let freeSpaceBefore = diskCommands.getFreeSpace()
            
            if wow {
                cleanCommands.all()
            } else if anyFlag {
                cleanCommands.default()
                if trash {
                    cleanCommands.trash()
                }
                
                if additional {
                    cleanCommands.additional()
                }
                
                if directories {
                    cleanCommands.directories()
                }
            } else {
                cleanCommands.default()
            }
            
            guard let bytes = diskCommands.getFreeSpace(relativeTo: freeSpaceBefore) else {
                Log.done()
                return
            }
            
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            Log.done("\(formatter.string(fromByteCount: Int64(bytes)).cyan) of space was saved.")
        }
        
        var anyFlag: Bool {
            additional || directories || trash || wow
        }
    }
}
