//
//  IP.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct IP: ParsableCommand {
        @OptionGroup var options: Options
        
        static var configuration = CommandConfiguration(
            commandName: "ip",
            abstract: "Prints your global IP address"
        )
        
        func run() throws {
            try options.load()
            
            guard let url = Configuration.shared.sources.ip else {
                Log.error("Invalid URL")
                return
            }
            
            let (rawData, response, error) = Very.urlSession.synchronousDataTask(with: url)
            
            guard response.isSuccess, let data = rawData, let text = String(data: data, encoding: .utf8) else {
                Log.error(error)
                return
            }
            
            Log.message(text)
        }
    }
}
