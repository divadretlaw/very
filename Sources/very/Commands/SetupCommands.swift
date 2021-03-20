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
        guard shell("which brew") == 0 else { return }
        
        Log.message(Log.Icon.package, "Installing packages...")
        packages.forEach { shell("brew install \($0)") }
    }
    
    static func install(casks: [String]) {
        // Install requires homebrew to be installed
        guard shell("which brew") == 0 else { return }
        
        Log.message(Log.Icon.package, "Installing casks...")
        casks.forEach { shell("brew install --cask \($0)") }
    }
    
    static func tap(repositories: [String]) {
        // Tap requires homebrew to be installed
        guard shell("which brew") == 0 else { return }
        
        Log.message(Log.Icon.package, "Tapping repositories...")
        repositories.forEach { shell("brew tap \($0)") }
        shell("brew update")
    }
    
    static func open(_ open: [String]) {
        open.forEach { shell("open \($0)") }
    }
    
}
