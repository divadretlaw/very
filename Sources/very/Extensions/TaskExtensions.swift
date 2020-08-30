//
//  TaskExtensions.swift
//  very
//
//  Created by David Walter on 26.08.20.
//

import Foundation
import SwiftCLI

extension Task {
    static func isAvailable(command: String) -> Bool {
        do {
            let status = try Task.capture("command", "-v", command)
            return !status.stdout.isEmpty
        } catch {
            return false
        }
    }
}
