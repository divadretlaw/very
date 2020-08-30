//
//  File.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import Foundation
import SwiftCLI

extension Very {
    class Gitignore: Command {
        let name = "gitignore"
        let shortDescription = "Loads a .gitignore file from gitignore.io"
        
        @CollectedParam var array: [String]
        
        func execute() throws {
            Log.message("🌐", "Downloading .gitignore file...")
            
            guard let path = array.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                let url = URL(string: "https://www.gitignore.io/api/\(path)") else {
                    Log.error("Invalid URL.")
                    return
            }
            
            let (rawData, response, error) = URLSession.shared.synchronousDataTask(with: url)
            
            guard response.isSuccess, let data = rawData else {
                Log.error(error)
                return
            }
            
            guard let fileURL = URL(string: "file://\(FileManager.default.currentDirectoryPath)")?.appendingPathComponent(".gitignore") else {
                Log.error(nil)
                return
            }
            
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
