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
    
    func all() async throws {
        try await `default`()
        trash()
        try await additional()
        directories()
    }
    
    func `default`() async throws {
        Log.message(Log.Icon.clean, "Cleaning system...")
        
        if let main = await configuration.packageManagers.getMain() {
            try await packageManager(main)
        }
        
        for item in configuration.packageManagers.getAdditional() {
            try await packageManager(item)
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
    
    func additional() async throws {
        let cleanCommands = configuration.clean.commands
        guard !cleanCommands.isEmpty else { return }
        
        for cleanCommand in cleanCommands {
            let script = Script(cleanCommand)
            try await script()
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
                let files = try fileManager.contentsOfDirectory(
                    at: URL(fileURLWithPath: cleanDirectory.expandingTildeInPath),
                    includingPropertiesForKeys: nil
                )
                for file in files {
                    try fileManager.removeItem(at: file)
                }
            } catch {
                Log.error("Unable to clean '\(cleanDirectory)'", error.localizedDescription)
            }
        }
    }
    
    func packageManager(_ packageManager: PackageManager.Main) async throws {
        guard await packageManager.isAvailable else { return }
        let script = Script(packageManager.clean)
        try await script()
    }
    
    func packageManager(_ packageManager: PackageManager.Additional) async throws {
        guard await packageManager.isAvailable else { return }
        let script = Script(packageManager.clean)
        try await script()
    }
}
