import Foundation

struct InvoiceHistory: Equatable, Hashable {
    let id: String
    let invoice: Invoice
    let supplier: Supplier
    
    static var mock: InvoiceHistory {
        InvoiceHistory(id: "", invoice: Invoice.mock, supplier: Supplier.mock)
    }
}

