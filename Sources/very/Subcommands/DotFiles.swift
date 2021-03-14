//
//  DotFiles.swift
//  very
//
//  Created by David Walter on 14.03.21.
//

import Foundation
import SwiftCLI

extension Very {
    class DotFiles: Command {
        let name = "dotfiles"
        let shortDescription = "Prints your global IP address"
        
        @Flag("-i", "--init", description: "Initialize dotFiles")
        var shouldInit: Bool
        
        @Key("-h", "--home", description: "")
        var home: String?
        
        func execute() throws {
            guard let dotFiles = Configuration.shared.sources.dotFiles else {
                Log.error("No configuration for dotFiles found")
                return
            }
            
            let home = self.home ?? "~"
            
            if shouldInit {
                Log.message(Log.Icon.notes, "Intializing dotfiles")
                let initScript = """
                cd \(home)
                git init
                git config --local status.showUntrackedFiles no
                git remote add origin \(dotFiles.repository)
                git branch -M main
                git pull origin main
                git branch --set-upstream-to=origin/main main
                """
                try Task.run(bash: initScript)
                
                let password = Input.readLine(prompt: "Enter the shared secret:", secure: true, validation: [], errorResponse: nil)
                let updateScript = """
                cd \(home)
                git fetch
                git pull
                git secret reveal -f -p \(password)
                """
                try Task.run(bash: updateScript)
            } else {
                Log.message(Log.Icon.notes, "Updating dotfiles")
                let script = """
                cd \(home)
                git fetch
                git pull --rebase
                git secret reveal -f
                """
                try Task.run(bash: script)
            }
        }
    }
}
