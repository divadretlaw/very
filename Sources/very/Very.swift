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
struct Very: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "very",
        abstract: "very",
        version: "3.0.0",
        subcommands: [
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
    )
    
    /// Rerun as with sudo
    static func sudo() {
        var arguments = [] as [String]
        arguments.append(contentsOf: ProcessInfo.processInfo.arguments)
        if !arguments.contains("--path"), let path = Configuration.url?.path {
            arguments.append(contentsOf: ["--path", path])
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
    
    func load() throws {
        guard let path = configuration else {
            try Configuration.load()
            return
        }
        
        try Configuration.load(path: path)
    }
}
