//
//  DotFiles.swift
//  very
//
//  Created by David Walter on 14.03.21.
//

import ArgumentParser
import Foundation
import Shell

extension Very {
    struct DotFiles: ParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "dotfiles",
            abstract: "Init and update dotFiles in your home directory"
        )
        
        @Option(name: .customLong("init"))
        var origin: String?
        
        @Option
        var home: String?
        
        func run() throws {
            try options.load()
            
            let home = home ?? "~"
            
            if let origin = origin {
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
                Shell.run(initScript)
                
                let updateScript = """
                cd \(home)
                git fetch
                git pull
                brew install git-secret
                git secret reveal -f
                """
                Shell.run(updateScript)
            } else {
                Log.message(Log.Icon.notes, "Updating dotfiles")
                let script = """
                cd \(home)
                git fetch
                git pull --rebase
                git secret reveal -f
                """
                Shell.run(script)
            }
        }
    }
}
