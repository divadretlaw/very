//
//  IP.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import SwiftCLI

extension Very {
    class IP: Command {
        let name = "ip"
        let shortDescription = "Prints your global IP address"

        func execute() throws {
            guard let url = Configuration.shared.sources.ip else {
                Log.error("Invalid URL")
                return
            }
            
            let (rawData, response, error) = URLSession.shared.synchronousDataTask(with: url)
            
            guard response.isSuccess, let data = rawData, let text = String(data: data, encoding: .utf8) else {
                Log.error(error)
                return
            }
            
            Log.message(text)
        }
    }
}
