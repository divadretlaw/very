//
//  VeryActor.swift
//  very
//
//  Created by David Walter on 12.06.24.
//

import Foundation

@globalActor actor VeryActor {
    static let shared = VeryActor()
    
    var configuration: Configuration!
    var url: URL?
    
    func load(path: String?) throws {
        let url: URL
        let configuration: Configuration

        if let path = path, FileManager.default.fileExists(atPath: path) {
            url = URL(fileURLWithPath: path)
            Log.debug("Using provided configuration Path: \(url.path)")
            configuration = try Configuration(contentsOf: url)
        } else if FileManager.default.fileExists(atPath: "./very.json") {
            url = URL(fileURLWithPath: "./very.json")
            Log.debug("Using local configuration: \(url.path)")
            configuration = try Configuration(contentsOf: url)
        } else if FileManager.default.fileExists(atPath: "~/.config/very/very.json".expandingTildeInPath) {
            url = URL(fileURLWithPath: "~/.config/very/very.json".expandingTildeInPath)
            Log.debug("Using user configuration: \(url.path)")
            configuration = try Configuration(contentsOf: url)
        } else {
            Log.warning("No configuration was found.")
            Log.message(Log.Icon.info, "Generating default configuration...")
            url = URL(fileURLWithPath: "~/.config/very/very.json".expandingTildeInPath)
            configuration = Configuration()
            let directory = url.deletingLastPathComponent()
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: [:])

            try configuration.jsonData.write(to: url)
            Log.message(Log.Icon.info, "Default configuration was stored at \(Log.path("~/.config/very/very.json")).")
        }

        self.configuration = configuration
        self.url = url
        
        Log.debug("Loaded configuration from \(url):")
        #if DEBUG
        Log.message(configuration.description)
        #endif
    }
}
