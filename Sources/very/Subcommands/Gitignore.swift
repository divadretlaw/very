//
//  Gitignore.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Gitignore: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static let configuration = CommandConfiguration(
            commandName: "gitignore",
            abstract: "Loads a .gitignore file from gitignore.io"
        )
        
        @Argument
        var array: [String] = []
        
        func run() async throws {
            _ = try await options.load()
            
            Log.message(Log.Icon.internet, "Downloading .gitignore file...")

            guard let path = array.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                  let url = URL(string: "https://www.gitignore.io/api/\(path)") else {
                Log.error("Invalid URL.")
                return
            }

            do {
                let (data, response) = try await Very.urlSession.data(from: url)
                
                guard response.isSuccess else {
                    return
                }
                
                let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(".gitignore")
                Log.debug("\(fileURL)")
                
                try data.write(to: fileURL)
            } catch {
                Log.error(error)
            }
        }
    }
}
