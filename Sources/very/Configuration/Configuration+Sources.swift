//
//  Configuration+Sources.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation

extension Configuration {
    struct Sources: Codable {
        let downloadtest: URL?
        let ip: URL?
        let wallpaper: URL?
        let ping: String
        let hosts: Hosts?
    }
}
