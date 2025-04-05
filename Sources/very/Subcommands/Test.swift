//
//  Test.swift
//  very
//
//  Created by David Walter on 21.03.21.
//

#if DEBUG
import Foundation
import ArgumentParser
import Shell

extension Very {
    struct Test: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static let configuration = CommandConfiguration(
            commandName: "test",
            abstract: "DEBUG only: Run some test command"
        )
        
        // MARK: - AsyncParsableCommand
        
        mutating func run() async throws {
            try await options.load()
            print("Hello World")
            let command = Command("sudo", "echo", "Hello")
            try await command()
        }
    }
}
#endif
