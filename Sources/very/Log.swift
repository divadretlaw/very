//
//  Log.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import Rainbow

struct Log {
    static var standardError = FileHandle.standardError
    
    static func message(_ items: String..., separator: String = " ", terminator: String = "\n") {
        let output = items.joined(separator: separator)
        print(output, separator: separator, terminator: terminator)
    }
    
    static func done() {
        print("✅ Done.")
    }
    
    static func debug(_ items: String..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        let output = "🕵️‍♂️  ".appending(items.joined(separator: separator))
        print(output.black.onYellow, separator: separator, terminator: terminator)
        #endif
    }
    
    static func warning(_ items: String..., separator: String = " ", terminator: String = "\n") {
        let output = "⚠️  ".appending(items.joined(separator: separator))
        print(output.yellow, separator: separator, terminator: terminator)
    }
    
    static func error(_ error: Error?) {
        if let error = error {
            Log.error(error.localizedDescription.red)
        } else {
            Log.error("Unknown Error.".red)
        }
    }
    
    static func error(_ items: String..., separator: String = " ", terminator: String = "\n") {
        let output = "❌ ".appending(items.joined(separator: separator))
        print(output.red, separator: separator, terminator: terminator, to: &standardError)
    }
    
    static func fatal(_ items: String..., separator: String = " ", terminator: String = "\n") -> Never {
        let output = "☠️  ".appending(items.joined(separator: separator))
        print(output.black.onRed, separator: separator, terminator: terminator, to: &standardError)
        return exit(1)
    }
    
    private init() {}
    
    static func url(_ url: URL) -> String {
        return Self.path(url.absoluteString.underline)
    }
    
    static func path(_ path: String) -> String {
        return "'\(path)'".blue
    }
}

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        write(data)
    }
}
