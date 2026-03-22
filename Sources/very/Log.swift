//
//  Log.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import ShellStyle

enum Log {
    enum Icon {
        static let done = "✅"

        static let info = "ℹ️ " // Looks better with trailing space
        static let warning = "⚠️ " // Looks better with trailing space
        static let debug = "🕵️‍♂️ " // Looks better with trailing space
        static let error = "❌ " // Looks better with trailing space
        static let fatal = "☠️ " // Looks better with trailing space

        static let internet = "🌐"
        static let wallpaper = "🖼 " // Looks better with trailing space
        static let notes = "📝"
        static let package = "📦"
        static let update = "🔄"

        static let clean = "♻️ " // Looks better with trailing space
        static let trash = "🗑 " // Looks better with trailing space
        static let directory = "📁"
        static let metal = "🎮"
    }

    static func header(_ header: String) {
        let content = "--- \(header) ---"
        let line = Array(repeating: "-", count: content.count)
            .joined()

        let message = """
        \(line)
        \(content)
        \(line)
        """.foregroundColor(.blue)
        Log.message(message)
    }

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
        print(output.foregroundColor(.black).backgroundColor(.yellow), separator: separator, terminator: terminator)
        #endif
    }

    static func warning(_ items: String..., separator: String = " ", terminator: String = "\n") {
        let output = Log.Icon.warning.appending(items.joined(separator: separator))
        print(output.foregroundColor(.yellow), separator: separator, terminator: terminator)
    }

    static func error(_ error: Error?) {
        if let error = error {
            Log.error(error.localizedDescription.foregroundColor(.red))
        } else {
            Log.error("Unknown Error.".foregroundColor(.red))
        }
    }

    static func error(_ items: String..., separator: String = " ", terminator: String = "\n") {
        let output = Log.Icon.error.appending(items.joined(separator: separator))
        var standardError = FileHandle.standardError
        print(output.foregroundColor(.red), separator: separator, terminator: terminator, to: &standardError)
    }

    static func fatal(_ items: String..., separator: String = " ", terminator: String = "\n") -> Never {
        let output = Log.Icon.fatal.appending(items.joined(separator: separator))
        var standardError = FileHandle.standardError
        print(output.foregroundColor(.black).backgroundColor(.red), separator: separator, terminator: terminator, to: &standardError)
        return exit(1)
    }

    static func url(_ url: URL) -> String {
        path(url.absoluteString.underline())
    }

    static func path(_ path: String) -> String {
        "'\(path)'".foregroundColor(.blue)
    }
}

extension FileHandle: @retroactive TextOutputStream {
    public func write(_ string: String) {
        write(Data(string.utf8))
    }
}
