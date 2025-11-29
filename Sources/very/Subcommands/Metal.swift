//
//  Metal.swift
//  very
//
//  Created by David Walter on 23.02.25.
//

import Foundation
import ArgumentParser
import Shell

extension Very {
    struct Metal: AsyncParsableCommand {
        @OptionGroup var options: Options

        static let configuration = CommandConfiguration(
            commandName: "metal",
            abstract: "Metal Status / Helpers"
        )

        @Option(help: "Metal HUD")
        var hud: Bool?

        // MARK: - AsyncParsableCommand

        func run() async throws {
            try await options.load()

            switch hud {
            case true:
                let command = Command("/bin/launchctl", "setenv", "MTL_HUD_ENABLED", "1")
                try await command()
            case false:
                let command = Command("/bin/launchctl", "unsetenv", "MTL_HUD_ENABLED")
                try await command()
            default:
                break
            }

            let command = Command("/bin/launchctl", "getenv", "MTL_HUD_ENABLED")
            let output = try await command.capture()
            switch output.trimmingCharacters(in: .whitespacesAndNewlines) {
            case "1":
                Log.message("Metal HUD: on")
            default:
                Log.message("Metal HUD: off")
            }
        }
    }
}
