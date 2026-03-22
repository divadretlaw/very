//
//  Configuration+PackageManager.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import Shell

extension Configuration {
    struct PackageManagers: Codable {
        private let main: [PackageManager]
        private let additional: [PackageManager]

        init() {
            self.main = PackageManager.main
            self.additional = PackageManager.additional
        }

        init(main: [PackageManager], additional: [PackageManager]) {
            self.main = main
            self.additional = additional
        }

        func getMain() async -> PackageManager? {
            // Check all package manager in the config
            for packageManager in main {
                if await packageManager.isAvailable {
                    return packageManager
                }
            }
            // If non-available check the default main package managers pre-configured
            for packageManager in PackageManager.main {
                if await packageManager.isAvailable {
                    return packageManager
                }
            }
            return nil
        }

        func getAdditional() -> [PackageManager] {
            self.additional
        }

        // MARK: - Codable

        private enum CodingKeys: CodingKey {
            case main
            case additional
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.main = try container.decodeIfPresent([PackageManager].self, forKey: .main) ?? []
            self.additional = try container.decodeIfPresent([PackageManager].self, forKey: .additional) ?? []

        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            if !main.isEmpty {
                try container.encode(self.main, forKey: .main)
            }
            try container.encodeIfPresent(self.additional, forKey: .additional)
        }
    }
}

// MARK: - Pre-configured package managers

struct PackageManager: Codable {
    static let main: [PackageManager] = [.brew]
    static let additional: [PackageManager] = [.mas, .npm]

    let command: String
    let description: String

    let install: String
    let remove: String
    let clean: String?
    let update: String
    let upgrade: String?
    let systemUpgrade: String?
    let search: String
    let list: String

    init(
        command: String,
        description: String,
        install: String,
        remove: String,
        clean: String?,
        update: String,
        upgrade: String?,
        systemUpgrade: String? = nil,
        search: String,
        list: String
    ) {
        self.description = description
        self.command = command
        self.install = install
        self.remove = remove
        self.clean = clean
        self.update = update
        self.upgrade = upgrade
        self.systemUpgrade = systemUpgrade
        self.search = search
        self.list = list
    }

    var isAvailable: Bool {
        get async {
            await Command.isAvailable(command)
        }
    }

    // MARK: - Default implementations

    static let brew = PackageManager(
        command: "brew",
        description: "Homebrew",
        install: "brew install",
        remove: "brew remove",
        clean: "brew cleanup -s",
        update: "brew update",
        upgrade: "brew upgrade",
        systemUpgrade: "softwareupdate -i -a",
        search: "brew serach",
        list: "brew list"
    )

    static let mas = PackageManager(
        command: "mas",
        description: "Mac AppStore",
        install: "mas install",
        remove: "mas uninstall",
        clean: nil,
        update: "mas outdated",
        upgrade: "mas upgrade",
        search: "mas search",
        list: "mas list"
    )

    static let npm = PackageManager(
        command: "npm",
        description: "Node.js Package Manager",
        install: "npm -g install",
        remove: "npm -g remove",
        clean: nil,
        update: "npm -g update",
        upgrade: nil,
        search: "npm -g find",
        list: "npm -g list"
    )
}
