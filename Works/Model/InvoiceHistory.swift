import Foundation

struct InvoiceHistory: Equatable, Hashable {
    let id: String
    let invoice: Invoice
    let supplier: Supplier
}
