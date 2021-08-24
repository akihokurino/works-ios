import Foundation

struct Me: Equatable, Hashable {
    let id: String
    let suppliers: [Supplier]
    var sender: Sender?
    var bank: Bank?

    static var mock: Me {
        Me(id: "1", suppliers: [Supplier.mock], sender: nil, bank: nil)
    }

    var totalAmountInMonthly: Int {
        suppliers
            .filter { $0.billingType == .monthly }
            .map { $0.billingAmountIncludeTax }
            .reduce(0) { s1, s2 in
                s1 + s2
            }
    }
}
