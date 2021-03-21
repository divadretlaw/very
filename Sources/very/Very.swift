//
//  Very.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import Dispatch
import Shell
import SwiftCLI

class Very {
    static let name = "very"
    static let version = "2.1.1"
    
    fileprivate static let pathFlag = Key<String>("--path", description: "Specify a config path")
    let very: CLI
    
    init() {
        very = CLI(name: Very.name,
                   version: Very.version,
                   description: "Helpful utilities.")
        very.commands = [
            Very.Clean(),
            Very.Update(),
            Very.Hosts(),
            Very.Gitignore(),
            Very.IP(),
            Very.Ping(),
            Very.Wallpaper(),
            Very.DotFiles(),
            Very.Setup()
        ]
        
        #if DEBUG
        very.commands.append(Very.Test())
        #endif
        
        very.globalOptions.append(Very.pathFlag)
    }
    
    public func execute(arguments: [String]? = nil) {
        let status: Int32
        if let arguments = arguments {
            status = very.go(with: arguments)
        } else {
            status = very.go()
        }
        exit(status)
    }
    
    func help() {
        DispatchQueue.main.async {
            self.very.go(with: ["-h"])
            exit(0)
        }
    }
    
    func completions() {
        let generator = ZshCompletionGenerator(cli: self.very)
        generator.writeCompletions()
    }
    
    /// Rerun very as sudo
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
        config.httpAdditionalHeaders = ["User-Agent": "curl/0.0.0 \(Very.name)/\(Very.version)"]
        return URLSession(configuration: config)
    }()
}


extension Command {
    var path: String? {
        return Very.pathFlag.value
    }
}
