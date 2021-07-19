import Foundation

struct Supplier: Equatable, Hashable {
    let id: String
    let name: String
    let billingAmount: Int
    let billingType: GraphQL.SupplierBillingType
    
    static var mock: Supplier {
        Supplier(id: "1", name: "株式会社A", billingAmount: 200000, billingType: .monthly)
    }
}
