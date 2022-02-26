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
    struct Test: ParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "test",
            abstract: "DEBUG only: Run some test command"
        )
        
        mutating func run() throws {
            try options.load()
            print("Hello World")
        }
    }
}
#endif
