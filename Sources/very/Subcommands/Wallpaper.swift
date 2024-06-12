//
//  Wallpaper.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import ArgumentParser
import Foundation

extension Very {
    struct Wallpaper: AsyncParsableCommand {
        @OptionGroup var options: Options
        
        static let configuration = CommandConfiguration(
            commandName: "wallpaper",
            abstract: "Sets the wallpaper"
        )

        func run() async throws {
            let configuration = try await options.load()
            let commands = WallpaperCommands(configuration: configuration)
            
            guard let url = configuration.sources.wallpaper else {
                Log.error("Invalid URL.")
                return
            }
            Log.message(Log.Icon.wallpaper, "Downloading Wallpaper from \(Log.url(url))...")

            do {
                let (data, response) = try await Very.urlSession.data(from: url)
                
                guard response.isSuccess else {
                    return
                }
                
                guard let pictureDirectory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first else {
                    Log.error("No picture directory.")
                    return
                }
                
                let wallpaperURL = pictureDirectory.appendingPathComponent(data.fileName(name: "Wallpaper"))
                
                Log.debug("\(wallpaperURL)")
                try data.write(to: wallpaperURL)
                try commands.set(wallpaperURL)
                Log.done()
            } catch {
                Log.error(error)
            }
        }
    }
}
