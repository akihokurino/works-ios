import Combine
import ComposableArchitecture
import Firebase

enum InvoiceDetailTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .back:
            return .none
        case .onAppear:
            state.isLoading = true
            let invoiceId = state.invoice.id
            return GraphQLClient.shared.caller()
                .flatMap { caller in caller.downloadInvoicePDF(invoiceId: invoiceId) }
                .catchToEffect()
                .map(InvoiceDetailTCA.Action.downloaded)
        case .downloaded(.success(let url)):
            state.isLoading = false
            state.pdfURL = url
            return .none
        case .downloaded(.failure(let e)):
            state.isLoading = false
            return .none
        }
    }
}

extension InvoiceDetailTCA {
    enum Action: Equatable {
        case back
        case onAppear
        case downloaded(Result<URL, AppError>)
    }

    struct State: Equatable {
        let invoice: Invoice
        var isLoading: Bool = false
        var pdfURL: URL? = nil
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
