//
//  Configuration.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import ArgumentParser

struct Configuration: Codable {
    let packageManagers: PackageManager
    let sources: Sources
    let clean: Clean

    init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.allowsJSON5 = true
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self = try decoder.decode(Configuration.self, from: data)
    }

    init() {
        self.packageManagers = PackageManager()
        self.sources = Sources()
        self.clean = Clean()
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: CodingKey {
        case packageManagers
        case sources
        case clean
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.packageManagers = try container.decodeIfPresent(PackageManager.self, forKey: .packageManagers) ?? PackageManager()
        self.sources = try container.decodeIfPresent(Sources.self, forKey: .sources) ?? Sources()
        self.clean = try container.decodeIfPresent(Clean.self, forKey: .clean) ?? Clean()
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(packageManagers, forKey: .packageManagers)
        try container.encode(sources, forKey: .sources)
        try container.encode(clean, forKey: .clean)
    }
}

extension Data {
    init(_ configuration: Configuration) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        self = try encoder.encode(configuration)
    }
}
