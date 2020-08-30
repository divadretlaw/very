//
//  Very.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import Dispatch
import SwiftCLI

class Very {
    fileprivate static let pathFlag = Key<String>("--path", description: "Specify a config path")
    let very: CLI
    
    init() {
        very = CLI(name: "very",
                       version: "2.0.0",
                       description: "Helpful utilities.")
        very.commands = [
            Very.Clean(),
            Very.Update(),
            Very.Hosts(),
            Very.Gitignore(),
            Very.IP(),
            Very.Ping(),
            Very.Wallpaper()
        ]
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
    
    static func sudo() {
        let password = Input.readLine(prompt: "Password:", secure: true, validation: [], errorResponse: nil)
        var arguments = ["-S"]
        arguments.append(contentsOf: ProcessInfo.processInfo.arguments)

        let input = PipeStream()
        let task = Task(executable: "sudo",
                        arguments: arguments,
                        directory: nil,
                        stdout: Term.stdout,
                        stderr: Term.stderr,
                        stdin: input)
        task.runAsync()
        input <<< password
        task.finish()
    }
}


extension Command {
    var path: String? {
        return Very.pathFlag.value
    }
}
