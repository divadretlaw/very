//
//  DiskCommands.swift
//  very
//
//  Created by David Walter on 30.08.20.
//

import Foundation

struct DiskCommands {
    let configuration: Configuration
    
    func getFreeSpace() -> Int? {
        let url = URL(fileURLWithPath: "/")
        
        do {
            let values = try url.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            return values.volumeAvailableCapacity
        } catch {
            return nil
        }
    }
    
    func getFreeSpace(relativeTo: Int?) -> Int? {
        guard let before = relativeTo, let after = getFreeSpace() else { return nil }
        let bytes = before - after
        guard bytes > 0 else { return nil }
        return bytes
    }
}
