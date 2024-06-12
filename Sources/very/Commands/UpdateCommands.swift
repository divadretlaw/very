//
//  UpdateCommands.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import Shell

struct UpdateCommands {
    let configuration: Configuration
    
    func all() {
        `default`()
        system()
    }
    
    func `default`() {
        if let main = configuration.packageManagers.getMain() {
            packageManager(main)
        }
        
        for item in configuration.packageManagers.getAdditional() {
            packageManager(item)
        }
    }
    
    func system() {
        if let main = configuration.packageManagers.getMain() {
            systemUpgrade(main)
        }
    }
    
    private func packageManager(_ packageManager: PackageManager.Main) {
        guard packageManager.isAvailable else { return }
        
        Log.message(Log.Icon.package, "Updating packages using '\(packageManager.command)'...")
        Shell.run(packageManager.update)
        
        guard let upgrade = packageManager.upgrade else { return }
        Shell.run(upgrade)
    }
    
    private func packageManager(_ packageManager: PackageManager.Additional) {
        guard packageManager.isAvailable else { return }
        
        Log.message(Log.Icon.package, "Updating packages using '\(packageManager.command)'...")
        Shell.run(packageManager.update)
        
        guard let upgrade = packageManager.upgrade else { return }
        Shell.run(upgrade)
    }
    
    private func systemUpgrade(_ packageManager: PackageManager.Main) {
        guard packageManager.isAvailable, let systemUpgrade = packageManager.systemUpgrade else { return }
        Log.message(Log.Icon.update, "Upgrading System...")
        Shell.run(systemUpgrade)
    }
}
