//
//  DotFiles.swift
//  very
//
//  Created by David Walter on 14.03.21.
//

import Foundation
import SwiftCLI
import Shell

extension Very {
    class DotFiles: Command {
        let name = "dotfiles"
        let shortDescription = "Init and update dotFiles in your home directory"
        
        @Key("-i", "--init", description: "")
        var origin: String?
        
        @Key("-h", "--home", description: "")
        var home: String?
        
        func execute() throws {
            let home = self.home ?? "~"
            
            if let origin = self.origin {
                Log.message(Log.Icon.notes, "Intializing dotfiles")
                let initScript = """
                cd \(home)
                git init
                git config --local status.showUntrackedFiles no
                git remote add origin \(origin)
                git branch -M main
                git pull origin main
                git branch --set-upstream-to=origin/main main
                """
                shell(script: initScript)
                
                let updateScript = """
                cd \(home)
                git fetch
                git pull
                brew install git-secret
                git secret reveal -f
                """
                shell(script: updateScript)
            } else {
                Log.message(Log.Icon.notes, "Updating dotfiles")
                let script = """
                cd \(home)
                git fetch
                git pull --rebase
                git secret reveal -f
                """
                shell(script: script)
            }
        }
    }
}
