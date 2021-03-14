//
//  Wallpaper.swift
//  very
//
//  Created by David Walter on 28.08.20.
//

import Foundation
import SwiftCLI

extension Very {
    class Wallpaper: Command {
        let name: String = "wallpaper"
        let shortDescription = "Sets the wallpaper"

        func execute() throws {
            guard let url = Configuration.shared.sources.wallpaper else {
                Log.error("Invalid URL.")
                return
            }
            Log.message(Log.Icon.wallpaper, "Downloading Wallpaper from \(Log.url(url))...")

            let (rawData, response, error) = Very.urlSession.synchronousDataTask(with: url)

            guard response.isSuccess, let data = rawData else {
                Log.error(error)
                return
            }

            guard let pictureDirectory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first else {
                Log.error("No picture directory.")
                return
            }

            let wallpaperURL = pictureDirectory.appendingPathComponent(data.fileName(name: "Wallpaper"))
            
            do {
                Log.debug("\(wallpaperURL)")
                try data.write(to: wallpaperURL)
                try WallpaperCommands.set(wallpaperURL)
                Log.done()
            } catch {
                Log.error(error)
            }
        }
    }
}
