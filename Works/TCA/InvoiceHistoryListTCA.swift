import Combine
import ComposableArchitecture
import Firebase

enum InvoiceHistoryListTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .presentInvoiceDetailView(let invoice):
            state.invoiceDetailState = InvoiceDetailTCA.State(invoice: invoice)
            return .none
        case .popInvoiceDetailView:
            state.invoiceDetailState = nil
            return .none
        case .fetchHistoryList:
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceHistoryList() }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceHistoryListTCA.Action.historyList)
        case .refreshHistoryList:
            state.isRefreshing = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceHistoryList() }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceHistoryListTCA.Action.historyList)
        case .historyList(.success(let items)):
            state.isRefreshing = false
            state.histories = items
            return .none
        case .historyList(.failure(_)):
            state.isRefreshing = false
            return .none
            
        case .propagateInvoiceDetail(let action):
            switch action {
            default:
                return .none
            }
        }
    }
    .presents(
        InvoiceDetailTCA.reducer,
        state: \.invoiceDetailState,
        action: /InvoiceHistoryListTCA.Action.propagateInvoiceDetail,
        environment: { _environment in
            InvoiceDetailTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension InvoiceHistoryListTCA {
    enum Action: Equatable {
        case fetchHistoryList
        case refreshHistoryList
        case historyList(Result<[InvoiceHistory], AppError>)
        case presentInvoiceDetailView(Invoice)
        case popInvoiceDetailView
        
        case propagateInvoiceDetail(InvoiceDetailTCA.Action)
    }

    struct State: Equatable {
        var isRefreshing: Bool = false
        var histories: [InvoiceHistory] = []
        var invoiceDetailState: InvoiceDetailTCA.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
