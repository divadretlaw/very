//
//  Metal.Position.swift
//  very
//
//  Created by David Walter on 22.03.26.
//

import Foundation
import ArgumentParser

extension Very.Metal {
    enum Position: String, Codable, ExpressibleByArgument, CustomStringConvertible, Sendable {
        case topleft
        case topcenter
        case topright
        case centerleft
        case centered
        case centerright
        case bottomright
        case bottomcenter
        case bottomleft

        // MARK: - CustomStringConvertible

        var description: String {
            rawValue
        }
    }
}

