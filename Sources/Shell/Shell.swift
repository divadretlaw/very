//
//  Shell.swift
//  Shell
//
//  Created by David Walter on 21.03.21.
//

import Foundation
import ShellCore

public struct Shell {
    @discardableResult
    public static func run(_ script: String) -> Int {
        let result = shell(script)
        return Int(result)
    }
    
    public static func isAvailable(_ command: String) -> Bool {
        return shell("command -v \(command) > /dev/null 2>&1") == 0
    }
    
    private init() {
        
    }
}
