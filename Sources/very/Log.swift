//
//  Log.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import Rainbow

struct Log {
    struct Icon {
        static let done = "✅"
        
        static let info = "ℹ️ "
        static let warning = "⚠️ "
        static let debug = "🕵️‍♂️ "
        static let error = "❌ "
        static let fatal = "☠️ "
        
        static let internet = "🌐"
        static let wallpaper = "🖼 "
        static let notes = "📝"
        static let package = "📦"
        static let update = "🔄"
        
        static let clean = "♻️ "
        static let trash = "🗑 "
        static let directory = "📁"
    }
    
    static var standardError = FileHandle.standardError
    
    static func message(_ items: String..., separator: String = " ", terminator: String = "\n") {
        let output = items.joined(separator: separator)
        print(output, separator: separator, terminator: terminator)
    }
    
    static func done(_ message: String? = nil) {
        if let message = message {
            print(Log.Icon.done, "Done", "-", message)
        } else {
            print(Log.Icon.done, "Done.")
        }
    }
    
    static func debug(_ items: String..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        let output = Log.Icon.debug.appending(items.joined(separator: separator))
        print(output.black.onYellow, separator: separator, terminator: terminator)
        #endif
    }
    
    static func warning(_ items: String..., separator: String = " ", terminator: String = "\n") {
        let output = Log.Icon.warning.appending(items.joined(separator: separator))
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
        let output = Log.Icon.error.appending(items.joined(separator: separator))
        print(output.red, separator: separator, terminator: terminator, to: &standardError)
    }
    
    static func fatal(_ items: String..., separator: String = " ", terminator: String = "\n") -> Never {
        let output = Log.Icon.fatal.appending(items.joined(separator: separator))
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
