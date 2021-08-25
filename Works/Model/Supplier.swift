import Foundation

struct Supplier: Equatable, Hashable {
    let id: String
    let name: String
    let billingAmountIncludeTax: Int
    let billingAmountExcludeTax: Int
    let billingType: GraphQL.GraphQLBillingType
    let endYm: String?
    let subject: String
    let subjectTemplate: String

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

    var endYmString: String {
        guard let endYm = endYm else {
            return ""
        }

        let year = endYm.split(separator: "-")[0]
        let month = endYm.split(separator: "-")[1]
        
        return "\(year)年\(month)月"
    }

    static var mock: Supplier {
        Supplier(id: "1",
                 name: "株式会社A",
                 billingAmountIncludeTax: 220000,
                 billingAmountExcludeTax: 200000,
                 billingType: .monthly,
                 endYm: nil,
                 subject: "件名",
                 subjectTemplate: "")
    }
}
