import Foundation

struct Bank: Equatable, Hashable {
    let id: String
    let name: String
    let code: String
    let accountType: GraphQL.GraphQLBankAccountType
    let accountNumber: String

    var accountTypeText: String {
        switch accountType {
        case .savings:
            return "普通"
        case .checking:
            return "当座"
        default:
            return ""
        }
    }

    static var mock: Bank {
        Bank(id: "", name: "", code: "", accountType: .savings, accountNumber: "")
    }
}
