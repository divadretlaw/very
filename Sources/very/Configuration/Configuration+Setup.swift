//
//  Configuration+Setup.swift
//  very
//
//  Created by David Walter on 20.03.21.
//

import Foundation

extension Configuration {
    struct Setup: Codable {
        let packages: [String]
        let casks: [String]
        let taps: [String]
        let open: [String]
        let additional: [SetupCommand]
        
        init(
            packages: [String],
            casks: [String],
            taps: [String],
            open: [String],
            additional: [SetupCommand]
        ) {
            self.packages = packages
            self.casks = casks
            self.taps = taps
            self.open = open
            self.additional = additional
        }
    }
    
    struct SetupCommand: Codable {
        let comment: String
        let command: String
    }
}
