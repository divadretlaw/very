//
//  Configuration.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation

struct Configuration: Codable, CustomStringConvertible {
    static var shared: Configuration!
    
    let packageManagers: PackageManager
    let sources: Sources
    let clean: Clean
    
    static func load(path: String? = nil) throws {
        if let path = path {
            Configuration.shared = try Configuration(path: URL(fileURLWithPath: path))
        } else {
            Configuration.shared = try Configuration()
        }
        Log.debug("Loaded configuration:")
        #if DEBUG
        Log.message(Configuration.shared.description)
        #endif
    }
    
    init(path: URL? = nil) throws {
        let url: URL
        if let path = path, FileManager.default.fileExists(atPath: path.path) {
            url = path
            Log.debug("Using provided configuration Path: \(url.path)")
        } else if FileManager.default.fileExists(atPath: "./very.json") {
            url = URL(fileURLWithPath: "./very.json")
            Log.debug("Using local configuration: \(url.path)")
        } else if FileManager.default.fileExists(atPath: "~/.config/very/very.json".expandingTildeInPath) {
            url = URL(fileURLWithPath: "~/.config/very/very.json".expandingTildeInPath)
            Log.debug("Using user configuration: \(url.path)")
        } else {
            Log.warning("No configuration was found.")
            Log.message("ℹ️ ", "Generating default configuration...")
            
            self = Configuration(values: true)
            
            url = URL(fileURLWithPath: "~/.config/very/very.json".expandingTildeInPath)
            let directory = url.deletingLastPathComponent()
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: [:])
            
            try self.data.write(to: url)
            
            Log.message("ℹ️ ", "Default configuration was stored at \(Log.path("~/.config/very/very.json")).")
            return
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self = try decoder.decode(Configuration.self, from: data)
    }
    
    private init(values: Bool) {
        self.packageManagers = PackageManager(main: [],
                                              additional: [])
        
        self.sources = Sources(downloadtest: nil,
                               ip: values ? URL(string: "http://ipecho.net/plain") : nil,
                               wallpaper: nil,
                               ping: "1.1.1.1",
                               hosts: values ?
                                Hosts(sudo: true,
                                      defaults: true,
                                      source: URL(string: "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts")!,
                                      target: "/etc/hosts")
                                : nil)
        
        self.clean = Clean(commands: [],
                           directories: [])
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return String(data: self.data, encoding: .utf8)!
    }
    
    var data: Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        if #available(OSX 10.15, *) {
            encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        } else {
            encoder.outputFormatting = [.prettyPrinted]
        }
        
        return try! encoder.encode(self)
    }
}
