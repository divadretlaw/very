//
//  StringExtensions.swift
//  very
//
//  Created by David Walter on 05.07.20.
//

import Foundation

extension String {
    var expandingTildeInPath: String {
        NSString(string: self).expandingTildeInPath
    }
}
