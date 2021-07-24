import Foundation

struct Invoice: Equatable, Hashable {
    let id: String
    let issueYMD: String
    let paymentDueOnYMD: String
    let invoiceNumber: String
    let paymentStatus: GraphQL.GraphQLPaymentStatus
    let invoiceStatus: GraphQL.GraphQLInvoiceStatus
    let recipientName: String
    let subject: String
    let totalAmount: Int
    let tax: Int

    var paymentStatusText: String {
        switch paymentStatus {
        case .unPaid:
            return "未支払"
        case .paid:
            return "支払済"
        default:
            return ""
        }
    }

    var invoiceStatusText: String {
        switch invoiceStatus {
        case .unSubmitted:
            return "未請求"
        case .submitted:
            return "請求済"
        default:
            return ""
        }
    }

    static var mock: Invoice {
        Invoice(id: "1", issueYMD: "2021-05-30", paymentDueOnYMD: "2021-06-30", invoiceNumber: "1234", paymentStatus: .paid, invoiceStatus: .submitted, recipientName: "", subject: "請求書件名", totalAmount: 200000, tax: 20000)
    }
}
