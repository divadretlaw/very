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
        if let path = path {
            let url = URL(fileURLWithPath: path)
            self.configuration = try Configuration(path: url)
            self.url = url
        } else {
            self.configuration = try Configuration(path: nil)
            self.url = nil
        }
        Log.debug("Loaded configuration:")
        #if DEBUG
        Log.message(configuration.description)
        #endif
    }
}
