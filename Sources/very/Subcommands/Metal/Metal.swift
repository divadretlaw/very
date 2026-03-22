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

        @Option(help: "Metal HUD enabled")
        var enabled: Bool?
        @Option(help: "Metal HUD alignment")
        var alignment: Position?
        @Option(parsing: .upToNextOption, help: "Metal HUD elements")
        var elements: [Metal.Element] = []

        @Flag
        var `default`: Bool = false

        // MARK: - AsyncParsableCommand

        mutating func run() async throws {
            try await options.load()

            if `default` {
                enabled = true
                alignment = .topright
                elements = [.device, .rosetta, .layersize, .memory, .fps, .thermal]
            }

            switch enabled {
            case true:
                let command = Command("/bin/launchctl", "setenv", "MTL_HUD_ENABLED", "1")
                try await command()
            case false:
                let command = Command("/bin/launchctl", "unsetenv", "MTL_HUD_ENABLED")
                try await command()
            default:
                break
            }

            switch alignment {
            case .some(let position):
                let command = Command("/bin/launchctl", "setenv", "MTL_HUD_ALIGNMENT", position.rawValue)
                try await command()
            default:
                break
            }

            if !elements.isEmpty {
                let command = Command("/bin/launchctl", "setenv", "MTL_HUD_ELEMENTS", elements.map(\.rawValue).joined(separator: ","))
                try await command()
            }

            Log.message(Log.Icon.metal, "Metal HUD")

            let isEnabledCommand = Command("/bin/launchctl", "getenv", "MTL_HUD_ENABLED")
            let isEnabled = try await isEnabledCommand.capture()
            switch isEnabled.trimmingCharacters(in: .whitespacesAndNewlines) {
            case "1":
                Log.message("▸ Is Enabled: \("on".foregroundColor(.green))")
            default:
                Log.message("▸ Is Enabled: \("off".foregroundColor(.red))")
            }

            let alignmentCommand = Command("/bin/launchctl", "getenv", "MTL_HUD_ALIGNMENT")
            let alignment = Position(rawValue: try await alignmentCommand.capture().trimmingCharacters(in: .whitespacesAndNewlines)) ?? .topright
            Log.message("▸ Alignment: \(alignment)")

            let elementsCommand = Command("/bin/launchctl", "getenv", "MTL_HUD_ELEMENTS")
            let elements = try await elementsCommand.capture()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: ",")
                .compactMap { Element(rawValue: String($0)) }
            Log.message("▸ Elements: \(elements)")
        }
    }
}
