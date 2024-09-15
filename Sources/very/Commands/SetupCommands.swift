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
    
    func install(packages: [String]) async throws {
        // Install requires homebrew to be installed
        guard await Command.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Installing packages...")
        for package in packages {
            let script = Script("brew install \(package)")
            try await script()
        }
    }
    
    func install(casks: [String]) async throws {
        // Install requires homebrew to be installed
        guard await Command.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Installing casks...")
        for package in casks {
            let script = Script("brew install \(package)")
            try await script()
        }
    }
    
    func tap(repositories: [String]) async throws {
        // Tap requires homebrew to be installed
        guard await Command.isAvailable("brew") else { return }
        
        Log.message(Log.Icon.package, "Tapping repositories...")
        for repository in repositories {
            let script = Script("brew install \(repository)")
            try await script()
        }
        let script = Script("brew update")
        try await script()
    }
    
    func open(_ open: [String]) async throws {
        Log.message(Log.Icon.info, "Opening links...")
        for link in open {
            let script = Script("brew install \(link)")
            try await script()
        }
    }
}
