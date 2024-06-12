//
//  Test.swift
//  very
//
//  Created by David Walter on 21.03.21.
//

#if DEBUG
import ArgumentParser
import Foundation

extension Very {
    struct Test: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static let configuration = CommandConfiguration(
            commandName: "test",
            abstract: "DEBUG only: Run some test command"
        )
        
        mutating func run() async throws {
            let _ = try await options.load()
            print("Hello World")
        }
    }
}
#endif
