//
//  ShellExtensions.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import Shell

@discardableResult
func shell(script: String) -> Int {
    for command in script.split(separator: "\n") {
        let result = Shell.shell(String(command))
        guard result == 0 else { return Int(result) }
    }
    return 0
}
