//
//  Configuration+Hosts.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation

extension Configuration {
    struct Hosts: Codable {
        let sudo: Bool
        let defaults: Bool
        let source: URL
        let target: String

        init() {
            self.sudo = true
            self.defaults = true
            self.source = URL(string: "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts")!
            self.target = "/etc/hosts"
        }

        init(
            sudo: Bool,
            defaults: Bool,
            source: URL,
            target: String
        ) {
            self.sudo = sudo
            self.defaults = defaults
            self.source = source
            self.target = target
        }
    }
}
