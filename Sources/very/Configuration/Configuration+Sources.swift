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
        let hosts: Hosts

        init() {
            self.downloadtest = nil
            self.ip = URL(string: "http://ipecho.net/plain")
            self.wallpaper = nil
            self.ping = "1.1.1.1"
            self.hosts = Hosts()
        }

        init(
            downloadtest: URL?,
            ip: URL?,
            wallpaper: URL?,
            ping: String,
            hosts: Configuration.Hosts
        ) {
            self.downloadtest = downloadtest
            self.ip = ip
            self.wallpaper = wallpaper
            self.ping = ping
            self.hosts = hosts
        }

        // MARK: - Codable

        private enum CodingKeys: CodingKey {
            case downloadtest
            case ip
            case wallpaper
            case ping
            case hosts
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.downloadtest = try container.decodeIfPresent(URL.self, forKey: .downloadtest)
            self.ip = try container.decodeIfPresent(URL.self, forKey: .ip)
            self.wallpaper = try container.decodeIfPresent(URL.self, forKey: .wallpaper)
            self.ping = try container.decodeIfPresent(String.self, forKey: .ping) ?? "1.1.1.1"
            self.hosts = try container.decodeIfPresent(Hosts.self, forKey: .hosts) ?? Hosts()
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(downloadtest, forKey: .downloadtest)
            try container.encodeIfPresent(ip, forKey: .ip)
            try container.encodeIfPresent(wallpaper, forKey: .wallpaper)
            try container.encodeIfPresent(ping, forKey: .ping)
            try container.encodeIfPresent(hosts, forKey: .hosts)
        }
    }
}
