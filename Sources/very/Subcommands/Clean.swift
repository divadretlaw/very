//
//  Clean.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation
import ArgumentParser

extension Very {
    struct Clean: AsyncParsableCommand {
        @OptionGroup var options: Options

        static let configuration = CommandConfiguration(
            commandName: "clean",
            abstract: "Cleans the system"
        )

        @Flag(help: "Runs additional clean commands.")
        var additional = false

        @Flag(help: "Removes contents of directories.")
        var directories = false

        @Flag(help: "Empties the trash.")
        var trash = false

        @Flag(help: "Runs all clean commands.")
        var wow = false

        // MARK: - AsyncParsableCommand

        func run() async throws {
            let configuration = try await options.load()
            let cleanCommands = CleanCommands(configuration: configuration)
            let diskCommands = DiskCommands(configuration: configuration)

            let freeSpaceBefore = diskCommands.getFreeSpace()

            if wow {
                try await cleanCommands.all()
            } else if anyFlag {
                try await cleanCommands.default()
                if trash {
                    await cleanCommands.trash()
                }

                if additional {
                    try await cleanCommands.additional()
                }

                if directories {
                    cleanCommands.directories()
                }
            } else {
                try await cleanCommands.default()
            }

            if let bytes = diskCommands.getFreeSpace(relativeTo: freeSpaceBefore) {
                let formatter = ByteCountFormatter()
                formatter.countStyle = .file
                Log.done("\(formatter.string(fromByteCount: Int64(bytes)).foregroundColor(.cyan)) of space was saved.")
            } else {
                Log.done()
            }
        }

        var anyFlag: Bool {
            additional || directories || trash || wow
        }
    }
}
