//
//  Install.swift
//  very
//
//  Created by David Walter on 26.08.20.
//

import Foundation
//import ArgumentParser
//
//extension Very {
//    struct Install: ParsableCommand {
//        static let configuration = CommandConfiguration(abstract: "Install one or more packages.")
//        
//        @Argument()
//        var array = [String]()
//        
//        func run() throws {
//            guard !array.isEmpty else {
//                self.exit(.error("Please provide at least one package to install."))
//            }
//            
//            guard let packageManager = Configuration.shared.packageManagers.getMain() else {
//                self.exit(.error("No package manager found."))
//            }
//            
//            waitUntilExit {
//                var command = [packageManager.install]
//                command.append(contentsOf: self.array)
//                
//                TaskHandler.shared.shell(command)?.waitUntilExit()
//                Self.exit()
//            }
//        }
//    }
//}
