//
//  Ping.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import SwiftCLI
import Shell

extension Very {
    class Ping: Command {
        let name = "ping"
        let shortDescription = "Runs quick ping test"
        
        @Key("-h", "--host", description: "")
        var host: String?
        
        func execute() throws {
            let host = self.host ?? Configuration.shared.sources.ping
            Log.message(Log.Icon.internet, "Starting ping test...")
            Shell.run("ping \(host)")
            Log.done()
        }
    }
}
