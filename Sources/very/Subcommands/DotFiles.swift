//
//  DotFiles.swift
//  very
//
//  Created by David Walter on 14.03.21.
//

import Foundation
import ArgumentParser
import Shell

extension Very {
    struct DotFiles: AsyncParsableCommand {
        @OptionGroup var options: Options

        static let configuration = CommandConfiguration(
            commandName: "dotfiles",
            abstract: "Init and update dotFiles in your home directory"
        )

        @Option(name: .customLong("init"))
        var origin: String?

        @Option
        var home: String?

        // MARK: - AsyncParsableCommand

        func run() async throws {
            try await options.load()

            let home = home ?? "~"

            if let origin = origin {
                Log.message(Log.Icon.notes, "Intializing dotfiles")
                let initScript = Script {
                    """
                    cd \(home)
                    git init
                    git config --local status.showUntrackedFiles no
                    git remote add origin \(origin)
                    git branch -M main
                    git pull origin main
                    git branch --set-upstream-to=origin/main main
                    """
                }
                try await initScript()

                let updateScript = Script {
                    """
                    cd \(home)
                    git fetch
                    git pull
                    brew install git-secret
                    git secret reveal -f
                    """
                }
                try await updateScript()
            } else {
                Log.message(Log.Icon.notes, "Updating dotfiles")
                let script = Script {
                    """
                    cd \(home)
                    git fetch
                    git pull --rebase
                    git secret reveal -f
                    """
                }
                try await script()
            }
        }
    }
}
