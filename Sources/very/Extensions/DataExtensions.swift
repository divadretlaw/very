//
//  File.swift
//
//
//  Created by David Walter on 28.08.20.
//

import Foundation

extension Data {
    func fileName(name: String = "file") -> String {
        var bytes: UInt8 = 0
        self.copyBytes(to: &bytes, count: 1)

        switch bytes {
        case 0xFF:
            return "\(name).jpeg"
        case 0x89:
            return "\(name).png"
        case 0x49, 0x4D:
            return "\(name).tiff"
        default:
            return name
        }
    }
}
