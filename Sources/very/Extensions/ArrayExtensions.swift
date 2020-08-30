//
//  File.swift
//
//
//  Created by David Walter on 26.08.20.
//

import Foundation

extension Array {
    mutating func prepend(_ value: Element) {
        self.insert(value, at: 0)
    }
}
