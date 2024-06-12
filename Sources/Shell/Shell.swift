//
//  Shell.swift
//  Shell
//
//  Created by David Walter on 21.03.21.
//

import Foundation
import ShellCore

public enum Shell {
    /// Run the given script on the shell
    /// - Parameter script: The script to run.
    /// - Returns: The return code of the script.
    @discardableResult public static func run(_ script: String) -> Int {
        let result = shell(script)
        return Int(result)
    }
    
    /// Run the given script on the shell
    /// - Parameter script: Callback to a script builder.
    /// - Returns: The return code of the script.
    @discardableResult public static func run(script: () -> String) -> Int {
        run(script())
    }
    
    /// Checks if a command is available
    /// - Parameter command: The command to check.
    /// - Returns: Whether the command is available.
    public static func isAvailable(_ command: String) -> Bool {
        guard let value = command.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return false
        }
        
        return shell("command -v \"\(value)\" > /dev/null 2>&1") == 0
    }
}
