import Foundation

struct Supplier: Equatable, Hashable {
    let id: String
    let name: String
    let billingAmountIncludeTax: Int
    let billingAmountExcludeTax: Int
    let billingType: GraphQL.GraphQLBillingType

    var billingTypeText: String {
        switch billingType {
        case .monthly:
            return "月々"
        case .oneTime:
            return "納品時"
        default:
            return ""
        }
    }

    static var mock: Supplier {
        Supplier(id: "1", name: "株式会社A", billingAmountIncludeTax: 220000, billingAmountExcludeTax: 200000, billingType: .monthly)
    }
}
