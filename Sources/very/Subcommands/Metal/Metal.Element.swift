//
//  Metal.Element.swift
//  very
//
//  Created by David Walter on 22.03.26.
//

import Foundation
import ArgumentParser

extension Very.Metal {
    enum Element: String, Codable, ExpressibleByArgument, CustomStringConvertible, Sendable {
        case device
        case rosetta
        case layersize
        case layerscale
        case memory
        case fps
        case frameinterval
        case gputime
        case thermal
        case frameintervalgraph
        case presentdelay
        case frameintervalhistogram
        case metalcpu
        case gputimeline
        case shaders
        case framenumber
        case disk
        case fpsgraph
        case toplabeledcommandbuffers
        case toplabeledencoders

        // MARK: - CustomStringConvertible

        var description: String {
            rawValue
        }
    }
}
