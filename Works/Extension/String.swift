//
//  String.swift
//  Works
//
//  Created by akiho on 2021/07/15.
//

import Foundation

extension String {
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
}
