//
//  WallpaperCommands.swift
//  very
//
//  Created by David Walter on 29.08.20.
//

import Foundation
import Wallpaper

struct WallpaperCommands {
    
    static func set(_ url: URL) throws {
        try Wallpaper.set(url, screen: .all, scale: .auto, fillColor: nil)
    }
    
}
