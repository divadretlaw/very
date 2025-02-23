//
//  Configuration.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import ArgumentParser

struct Configuration: Codable, CustomStringConvertible {
    let packageManagers: PackageManager
    let sources: Sources
    let clean: Clean
    
    let setup: Setup?
    
    init(path: URL?) throws {
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
            Log.message(Log.Icon.info, "Generating default configuration...")
            
            self = Configuration()
            
            url = URL(fileURLWithPath: "~/.config/very/very.json".expandingTildeInPath)
            let directory = url.deletingLastPathComponent()
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: [:])
            
            try jsonData.write(to: url)
            
            Log.message(Log.Icon.info, "Default configuration was stored at \(Log.path("~/.config/very/very.json")).")
            return
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self = try decoder.decode(Configuration.self, from: data)
    }
    
    private init() {
        self.packageManagers = PackageManager()
        
        let ip = URL(string: "http://ipecho.net/plain")
        let hosts = Hosts(
            sudo: true,
            defaults: true,
            source: URL(string: "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts")!,
            target: "/etc/hosts"
        )
        
        self.sources = Sources(
            downloadtest: nil,
            ip: ip,
            wallpaper: nil,
            ping: "1.1.1.1",
            hosts: hosts
        )
        
        self.clean = Clean(commands: [], directories: [])
        
        self.setup = nil
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        String(decoding: jsonData, as: UTF8.self)
    }
    
    private var jsonData: Data {
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
