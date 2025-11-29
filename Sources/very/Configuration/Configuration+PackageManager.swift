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

    init() {
        self.main = []
        self.additional = []
    }

    init(main: [Main], additional: [Additional]) {
        self.main = main
        self.additional = additional
    }

    func getMain() async -> Main? {
        // Check all package manager in the config and if non-available check the default
        // main package managers pre-configured
        for packageManager in main {
            if await packageManager.isAvailable {
                return packageManager
            }
        }
        for packageManager in Self.main {
            if await packageManager.isAvailable {
                return packageManager
            }
        }
        return nil
    }

    func getAdditional() -> [Additional] {
        var additional = Self.additional // pre-configured additionals
        additional.append(contentsOf: self.additional) // additionals from config
        return additional
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
            get async {
                await Command.isAvailable(command)
            }
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
            get async {
                await Command.isAvailable(command)
            }
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
        clean: "brew cleanup -s",
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
