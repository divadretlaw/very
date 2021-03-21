//
//  CleanCommands.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import Shell

struct CleanCommands {
    static func all() {
        CleanCommands.default()
        CleanCommands.trash()
        CleanCommands.additional()
        CleanCommands.directories()
    }
    
    static func `default`() {
        Log.message(Log.Icon.clean, "Cleaning system...")
        
        if let main = Configuration.shared.packageManagers.getMain() {
            CleanCommands.packageManager(main)
        }
        
        Configuration.shared.packageManagers.getAdditional().forEach {
            CleanCommands.packageManager($0)
        }
    }
    
    static func trash() {
        Log.message(Log.Icon.trash, "Emptying trash...")
        
        let source = """
tell application "Finder"
if length of (items in the trash as string) is 0 then return
empty trash
repeat until (count items of trash) = 0
delay 1
end repeat
end tell
"""
        
        guard let script = NSAppleScript(source: source) else {
            Log.error("Invalid Script.")
            return
        }
        
        var error: NSDictionary?
        script.executeAndReturnError(&error)
        
        if let error = error {
            Log.error("\(error)")
        }
    }
    
    static func additional() {
        let cleanCommands = Configuration.shared.clean.commands
        guard !cleanCommands.isEmpty else { return }
        
        cleanCommands.forEach {
            Shell.run($0)
        }
    }
    
    static func directories() {
        let cleanDirectories = Configuration.shared.clean.directories
        guard !cleanDirectories.isEmpty else {
            return
        }
        
        Log.message(Log.Icon.directory, "Cleaning directories...")
        let fileManager = FileManager.default
        
        cleanDirectories.forEach {
            Log.message("Cleaning '\($0)'")
            
            do {
                let files = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: $0.expandingTildeInPath), includingPropertiesForKeys: nil)
                try files.forEach {
                    try fileManager.removeItem(at: $0)
                }
            } catch {
                Log.error("Unable to clean '\($0)'", error.localizedDescription)
            }
        }
    }
    
    static func packageManager(_ packageManager: PackageManager.Main) {
        guard packageManager.isAvailable else { return }
        Shell.run(packageManager.clean)
    }
    
    static func packageManager(_ packageManager: PackageManager.Additional) {
        guard packageManager.isAvailable else { return }
        Shell.run(packageManager.clean)
    }
}
