//
//  SetupCommands.swift
//  very
//
//  Created by David Walter on 20.03.21.
//

import Foundation
import Shell

struct SetupCommands {
    let configuration: Configuration
    
    func install(packages: [String]) {
        // Install requires homebrew to be installed
        guard Shell.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Installing packages...")
        for package in packages {
            Shell.run("brew install \(package)")
        }
    }
    
    func install(casks: [String]) {
        // Install requires homebrew to be installed
        guard Shell.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Installing casks...")
        for package in casks {
            Shell.run("brew install \(package)")
        }
    }
    
    func tap(repositories: [String]) {
        // Tap requires homebrew to be installed
        guard Shell.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Tapping repositories...")
        for repository in repositories {
            Shell.run("brew install \(repository)")
        }
        Shell.run("brew update")
    }
    
    func open(_ open: [String]) {
        Log.message(Log.Icon.info, "Opening links...")
        for link in open {
            Shell.run("brew install \(link)")
        }
    }
}
