//
//  SetupCommands.swift
//  very
//
//  Created by David Walter on 20.03.21.
//

import Foundation
import Shell

struct SetupCommands {
    static func install(packages: [String]) {
        // Install requires homebrew to be installed
        guard Shell.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Installing packages...")
        packages.forEach { Shell.run("brew install \($0)") }
    }
    
    static func install(casks: [String]) {
        // Install requires homebrew to be installed
        guard Shell.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Installing casks...")
        casks.forEach { Shell.run("brew install --cask \($0)") }
    }
    
    static func tap(repositories: [String]) {
        // Tap requires homebrew to be installed
        guard Shell.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Tapping repositories...")
        repositories.forEach { Shell.run("brew tap \($0)") }
        Shell.run("brew update")
    }
    
    static func open(_ open: [String]) {
        Log.message(Log.Icon.info, "Opening links...")
        open.forEach { Shell.run("open \($0)") }
    }
}
