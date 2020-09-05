//
//  UpdateCommands.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import SwiftCLI

struct UpdateCommands {
    static func all() {
        UpdateCommands.default()
        UpdateCommands.system()
    }
    
    static func `default`() {
        if let main = Configuration.shared.packageManagers.getMain() {
            UpdateCommands.packageManager(main)
        }
        
        Configuration.shared.packageManagers.getAdditional().forEach {
            UpdateCommands.packageManager($0)
        }
    }
    
    static func system() {
        if let main = Configuration.shared.packageManagers.getMain() {
            UpdateCommands.systemUpgrade(main)
        }
    }
    
    private static func packageManager(_ packageManager: PackageManager.Main) {
        guard packageManager.isAvailable else { return }
        
        Log.message(Log.Icon.package, "Updating packages using '\(packageManager.command)'...")
        try? Task.run(bash: packageManager.update)
        
        guard let upgrade = packageManager.upgrade else { return }
        try? Task.run(bash: upgrade)
    }
    
    private static func packageManager(_ packageManager: PackageManager.Additional) {
        guard packageManager.isAvailable else { return }
        
        Log.message(Log.Icon.package, "Updating packages using '\(packageManager.command)'...")
        try? Task.run(bash: packageManager.update)
        
        guard let upgrade = packageManager.upgrade else { return }
        try? Task.run(bash: upgrade)
    }
    
    private static func systemUpgrade(_ packageManager: PackageManager.Main) {
        guard packageManager.isAvailable, let systemUpgrade = packageManager.systemUpgrade else { return }
        Log.message(Log.Icon.update, "Upgrading System...")
        try? Task.run(bash: systemUpgrade)
    }
}
