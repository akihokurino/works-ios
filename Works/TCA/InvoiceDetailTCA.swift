import Combine
import ComposableArchitecture
import Firebase

enum InvoiceDetailTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .back:
            return .none
        case .onAppear:
            state.isLoading = true
            let invoiceId = state.invoice.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.downloadInvoicePDF(invoiceId: invoiceId) }
                .flatMap { url in Downloader.shared.download(url: url) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceDetailTCA.Action.downloaded)
        case .downloaded(.success(let data)):
            state.isLoading = false
            state.pdf = data
            return .none
        case .downloaded(.failure(let e)):
            state.isLoading = false
            return .none
        case .delete:
            state.isLoading = true
            let id = state.invoice.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.deleteInvoice(id: id) }
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceDetailTCA.Action.deleted)
        case .deleted(.success(_)):
            state.isLoading = false
            return .none
        case .deleted(.failure(_)):
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
        case delete
        case deleted(Result<Bool, AppError>)
    }

    struct State: Equatable {
        let invoice: Invoice
        var isLoading: Bool = false
        var pdf: URL? = nil
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
