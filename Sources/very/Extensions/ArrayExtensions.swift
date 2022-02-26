//
//  ArrayExtensions.swift
//  very
//
//  Created by David Walter on 26.08.20.
//

import Foundation

extension Array {
    mutating func prepend(_ value: Element) {
        insert(value, at: 0)
    }
}
