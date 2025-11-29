//
//  GitIgnore.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import Foundation
import ArgumentParser

extension Very {
    struct GitIgnore: AsyncParsableCommand {
        @OptionGroup var options: Options

        static let configuration = CommandConfiguration(
            commandName: "gitignore",
            abstract: "Loads a .gitignore file from gitignore.io"
        )

        @Argument
        var array: [String] = []

        // MARK: - AsyncParsableCommand

        func run() async throws {
            try await options.load()

            Log.message(Log.Icon.internet, "Downloading .gitignore file...")

            guard
                let path = array.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                let url = URL(string: "https://www.gitignore.io/api/\(path)")
            else {
                Log.error("Invalid URL.")
                return
            }

            do {
                let (data, response) = try await Very.urlSession.data(from: url)

                guard response.isSuccess else {
                    Log.error("Unable to fetch data.")
                    return
                }

                let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(".gitignore")
                Log.debug(Log.url(fileURL))
                try data.write(to: fileURL)
            } catch {
                Log.error(error)
            }
        }
    }
}
