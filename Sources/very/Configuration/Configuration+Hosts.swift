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
    }
}
