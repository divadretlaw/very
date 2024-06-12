//
//  Configuration+PackageManager.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import Shell

struct PackageManager: Codable {
    private let main: [Main]
    private let additional: [Additional]

    func getMain() -> Main? {
        // Check all package manager in the config and if non-available check the default
        // main package managers pre-configured
        main.first { $0.isAvailable } ?? Self.main.first { $0.isAvailable }
    }
    
    func getAdditional() -> [Additional] {
        var additional = Self.additional // pre-configured additionals
        additional.append(contentsOf: self.additional) // additionals from config
        return additional
    }
    
    init() {
        self.main = []
        self.additional = []
    }
}

extension PackageManager {
    struct Main: Codable {
        let command: String
        let install: String
        let remove: String
        let clean: String
        let update: String
        let upgrade: String?
        let systemUpgrade: String?
        let search: String
        let list: String

        var isAvailable: Bool {
            Shell.isAvailable(command)
        }
    }
}

extension PackageManager {
    struct Additional: Codable {
        let id: String
        let description: String

        let command: String
        let install: String
        let remove: String
        let clean: String
        let update: String
        let upgrade: String?
        let search: String
        let list: String

        var isAvailable: Bool {
            Shell.isAvailable(command)
        }
    }
}

extension PackageManager {
    static let main = [PackageManager.brew]
    static let additional = [PackageManager.mas, PackageManager.npm]
    
    static let brew = PackageManager.Main(
        command: "brew",
        install: "brew install",
        remove: "brew remove",
        clean: "brew cleanup",
        update: "brew update",
        upgrade: "brew upgrade",
        systemUpgrade: "softwareupdate -i -a",
        search: "brew serach",
        list: "brew list"
    )
    
    static let mas = PackageManager.Additional(
        id: "mas",
        description: "Mac AppStore",
        command: "mas",
        install: "mas install",
        remove: "",
        clean: "",
        update: "mas outdated",
        upgrade: "mas upgrade",
        search: "mas search",
        list: "mas list"
    )
    
    static let npm = PackageManager.Additional(
        id: "npm",
        description: "Node.js Package Manager",
        command: "npm",
        install: "npm -g install",
        remove: "npm -g remove",
        clean: "",
        update: "npm -g update",
        upgrade: nil,
        search: "npm -g find",
        list: "npm -g list"
    )
}
