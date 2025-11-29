//
//  Configuration+Clean.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation

extension Configuration {
    struct Clean: Codable {
        let commands: [String]
        let directories: [String]

        init() {
            self.commands = []
            self.directories = []
        }

        init(
            commands: [String],
            directories: [String]
        ) {
            self.commands = commands
            self.directories = directories
        }
    }
}
