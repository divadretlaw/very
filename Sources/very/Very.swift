//
//  Very.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import ArgumentParser
import Shell

@main struct Very: AsyncParsableCommand {
    static let configuration = {
        var subcommands: [any ParsableCommand.Type] = [
            Clean.self,
            DotFiles.self,
            Gitignore.self,
            Hosts.self,
            IP.self,
            Metal.self,
            Ping.self,
            Setup.self,
            Update.self,
            Wallpaper.self
        ]
        #if DEBUG
        subcommands.append(Test.self)
        #endif
        return CommandConfiguration(
            commandName: "very",
            abstract: "very",
            version: "3.3.2",
            subcommands: subcommands
        )
    }()
    
    /// Rerun with sudo
    static func sudo() async throws {
        var arguments: [String] = []
        arguments.append(contentsOf: ProcessInfo.processInfo.arguments)
        if !arguments.contains("--configuration"), let path = await VeryActor.shared.url?.path {
            arguments.append(contentsOf: ["--configuration", path])
        }

        let script = UnsafeScript("sudo \(arguments.joined(separator: " "))")
        try await script()
    }

    static let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["User-Agent": "curl/0.0.0 very/\(Very.configuration.version)"]
        return URLSession(configuration: config)
    }()
}

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
