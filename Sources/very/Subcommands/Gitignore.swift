//
//  Gitignore.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Gitignore: ParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "gitignore",
            abstract: "Loads a .gitignore file from gitignore.io"
        )
        
        @Argument
        var array: [String] = []
        
        func run() throws {
            try options.load()
            Log.message(Log.Icon.internet, "Downloading .gitignore file...")

            guard let path = array.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                  let url = URL(string: "https://www.gitignore.io/api/\(path)") else {
                Log.error("Invalid URL.")
                return
            }

            let (rawData, response, error) = Very.urlSession.synchronousDataTask(with: url)

            guard response.isSuccess, let data = rawData else {
                Log.error(error)
                return
            }

            let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(".gitignore")
            Log.debug("\(fileURL)")

            do {
                try data.write(to: fileURL)
                Log.done()
            } catch {
                Log.error(error)
            }
        }
    }
}
