//
//  Int.swift
//  Works
//
//  Created by akiho on 2021/07/15.
//

import Foundation

extension Int {
    var numberString: String {
        guard self < 10 else { return "0" }
        return String(self)
    }
}
