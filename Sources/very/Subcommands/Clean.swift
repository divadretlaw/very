//
//  Clean.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Clean: ParsableCommand {
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
        
        func run() throws {
            try options.load()
            
            let freeSpaceBefore = DiskCommands.getFreeSpace()
            
            if wow {
                CleanCommands.all()
            } else if anyFlag {
                CleanCommands.default()
                if trash {
                    CleanCommands.trash()
                }
                
                if additional {
                    CleanCommands.additional()
                }
                
                if directories {
                    CleanCommands.directories()
                }
            } else {
                CleanCommands.default()
            }
            
            guard let bytes = DiskCommands.getFreeSpace(relativeTo: freeSpaceBefore) else {
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
