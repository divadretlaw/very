//
//  Test.swift
//  very
//
//  Created by David Walter on 21.03.21.
//

#if DEBUG
import Foundation
import SwiftCLI
import Shell

extension Very {
    class Test: Command {
        let name = "test"
        let shortDescription = "DEBUG only: Run some test command"
        
        func execute() throws {
            let home = "~"
            
            let script = """
            cd \(home)
            pwd
            """
            Shell.run(script)
        }
    }
}
#endif
