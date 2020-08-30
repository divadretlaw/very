//
//  CleanCommands.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import SwiftCLI

struct CleanCommands {
    static func all() {
        CleanCommands.default()
        CleanCommands.trash()
        CleanCommands.additional()
        CleanCommands.directories()
    }
    
    static func `default`() {
        Log.message("♻️ ", "Cleaning system...")
        
        if let main = Configuration.shared.packageManagers.getMain() {
            CleanCommands.packageManager(main)
        }
        
        Configuration.shared.packageManagers.getAdditional().forEach {
            CleanCommands.packageManager($0)
        }
    }
    
    static func trash() {
        Log.message("🗑 ", "Emptying trash...")
        // TODO: Empty the trash
    }
    
    static func additional() {
        let cleanCommands = Configuration.shared.clean.commands
        guard !cleanCommands.isEmpty else { return }
        
        cleanCommands.forEach {
            try? Task.run(bash: $0)
        }
    }
    
    static func directories() {
        let cleanDirectories = Configuration.shared.clean.directories
        guard !cleanDirectories.isEmpty else {
            return
        }
        
        Log.message("📁", "Cleaning directories...")
        let fileManager = FileManager.default
        
        cleanDirectories.forEach {
            Log.message("Cleaning '\($0)'")
            let files = try? fileManager.contentsOfDirectory(at: URL(fileURLWithPath: $0.expandingTildeInPath), includingPropertiesForKeys: nil)
            files?.forEach {
                try? fileManager.removeItem(at: $0)
            }
        }
    }
    
    static func packageManager(_ packageManager: PackageManager.Main) {
        guard packageManager.isAvailable else { return }
        try? Task.run(bash: packageManager.clean)
    }
    
    static func packageManager(_ packageManager: PackageManager.Additional) {
        guard packageManager.isAvailable else { return }
        try? Task.run(bash: packageManager.clean)
    }
}
