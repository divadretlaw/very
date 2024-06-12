//
//  Very.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import ArgumentParser
import Dispatch
import Foundation
import Shell

@main
struct Very: AsyncParsableCommand {
    static let configuration = {
        var subcommands: [any ParsableCommand.Type] = [
            Clean.self,
            DotFiles.self,
            Gitignore.self,
            Hosts.self,
            IP.self,
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
            version: "3.1.0",
            subcommands: subcommands
        )
    }()
    
    /// Rerun as with sudo
    static func sudo() async {
        var arguments: [String] = []
        arguments.append(contentsOf: ProcessInfo.processInfo.arguments)
        if !arguments.contains("--configuration"), let path = await VeryActor.shared.url?.path {
            arguments.append(contentsOf: ["--configuration", path])
        }
        
        Shell.run("sudo \(arguments.joined(separator: " "))")
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
    
    func load() async throws -> Configuration {
        try await VeryActor.shared.load(path: configuration)
        return await VeryActor.shared.configuration
    }
}
