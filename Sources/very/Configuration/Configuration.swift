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
    
    init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self = try decoder.decode(Configuration.self, from: data)
    }

    init() {
        self.packageManagers = PackageManager()
        self.sources = Sources()
        self.clean = Clean()
        self.setup = nil
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: CodingKey {
        case packageManagers
        case sources
        case clean
        case setup
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.packageManagers = try container.decodeIfPresent(PackageManager.self, forKey: .packageManagers) ?? PackageManager()
        self.sources = try container.decodeIfPresent(Sources.self, forKey: .sources) ?? Sources()
        self.clean = try container.decodeIfPresent(Clean.self, forKey: .clean) ?? Clean()
        self.setup = try container.decodeIfPresent(Setup.self, forKey: .setup)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(packageManagers, forKey: .packageManagers)
        try container.encode(sources, forKey: .sources)
        try container.encode(clean, forKey: .clean)
        try container.encodeIfPresent(setup, forKey: .setup)
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        String(decoding: jsonData, as: UTF8.self)
    }
    
    var jsonData: Data {
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
