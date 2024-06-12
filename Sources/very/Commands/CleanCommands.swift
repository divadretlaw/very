//
//  CleanCommands.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import Shell

struct CleanCommands {
    let configuration: Configuration
    
    func all() {
        `default`()
        trash()
        additional()
        directories()
    }
    
    func `default`() {
        Log.message(Log.Icon.clean, "Cleaning system...")
        
        if let main = configuration.packageManagers.getMain() {
            packageManager(main)
        }
        
        for item in configuration.packageManagers.getAdditional() {
            packageManager(item)
        }
    }
    
    func trash() {
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
    
    func additional() {
        let cleanCommands = configuration.clean.commands
        guard !cleanCommands.isEmpty else { return }
        
        for cleanCommand in cleanCommands {
            Shell.run(cleanCommand)
        }
    }
    
    func directories() {
        let cleanDirectories = configuration.clean.directories
        
        guard !cleanDirectories.isEmpty else {
            return
        }
        
        Log.message(Log.Icon.directory, "Cleaning directories...")
        let fileManager = FileManager.default
        
        for cleanDirectory in cleanDirectories {
            Log.message("Cleaning '\(cleanDirectory)'")
            
            do {
                let files = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: cleanDirectory.expandingTildeInPath),
                                                                includingPropertiesForKeys: nil)
                try files.forEach {
                    try fileManager.removeItem(at: $0)
                }
            } catch {
                Log.error("Unable to clean '\(cleanDirectory)'", error.localizedDescription)
            }
        }
    }
    
    func packageManager(_ packageManager: PackageManager.Main) {
        guard packageManager.isAvailable else { return }
        Shell.run(packageManager.clean)
    }
    
    func packageManager(_ packageManager: PackageManager.Additional) {
        guard packageManager.isAvailable else { return }
        Shell.run(packageManager.clean)
    }
}
