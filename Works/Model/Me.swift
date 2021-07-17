//
//  Me.swift
//  Works
//
//  Created by akiho on 2021/07/17.
//

import Foundation

struct Me: Equatable, Hashable {
    let id: String
    let suppliers: [Supplier]

    static var mock: Me {
        Me(id: "1", suppliers: [Supplier.mock])
    }

    var totalAmountInMonthly: Int {
        suppliers
            .filter { $0.billingType == .monthly }
            .map { $0.billingAmount }
            .reduce(0) { s1, s2 in
                s1 + s2
            }
    }
}