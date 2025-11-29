//
//  UpdateCommands.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import Shell

struct UpdateCommands {
    let configuration: Configuration

    func all() async throws {
        try await `default`()
        try await system()
    }

    func `default`() async throws {
        if let main = await configuration.packageManagers.getMain() {
            try await packageManager(main)
        }

        for item in configuration.packageManagers.getAdditional() {
            try await packageManager(item)
        }
    }

    func system() async throws {
        if let main = await configuration.packageManagers.getMain() {
            try await systemUpgrade(main)
        }
    }

    private func packageManager(_ packageManager: PackageManager.Main) async throws {
        guard await packageManager.isAvailable else { return }

        Log.message(Log.Icon.package, "Updating packages using '\(packageManager.command)'...")
        let updateScript = Script(packageManager.update)
        try await updateScript()

        guard let upgrade = packageManager.upgrade else { return }
        let upgradeScript = Script(upgrade)
        try await upgradeScript()
    }

    private func packageManager(_ packageManager: PackageManager.Additional) async throws {
        guard await packageManager.isAvailable else { return }

        Log.message(Log.Icon.package, "Updating packages using '\(packageManager.command)'...")
        let updateScript = Script(packageManager.update)
        try await updateScript()

        guard let upgrade = packageManager.upgrade else { return }
        let upgradeScript = Script(upgrade)
        try await upgradeScript()
    }

    private func systemUpgrade(_ packageManager: PackageManager.Main) async throws {
        guard await packageManager.isAvailable, let systemUpgrade = packageManager.systemUpgrade else { return }
        Log.message(Log.Icon.update, "Upgrading System...")
        let upgradeScript = Script(systemUpgrade)
        try await upgradeScript()
    }
}
