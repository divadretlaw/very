//
//  Options.swift
//  very
//
//  Created by David Walter on 29.11.25.
//

import Foundation
import ArgumentParser
import Shell

struct Options: ParsableArguments {
    @Option(help: "Overwrite the default configuration", completion: .file())
    var configuration: String?

    @discardableResult
    func load() async throws -> Configuration {
        ShellEnvironment.shared.set(environment: ["HOMEBREW_COLOR": "1"])

        try await VeryActor.shared.load(path: configuration)
        return await VeryActor.shared.configuration
    }
}
