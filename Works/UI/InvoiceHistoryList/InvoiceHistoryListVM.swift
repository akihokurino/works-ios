import Combine
import ComposableArchitecture
import Firebase

enum InvoiceHistoryListVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .presentInvoiceDetailView(let invoice):
            state.invoiceDetailState = InvoiceDetailVM.State(invoice: invoice)
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
                .map(InvoiceHistoryListVM.Action.historyList)
        case .refreshHistoryList:
            state.isRefreshing = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceHistoryList() }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceHistoryListVM.Action.historyList)
        case .historyList(.success(let items)):
            state.isRefreshing = false
            state.histories = items
            return .none
        case .historyList(.failure(_)):
            state.isRefreshing = false
            return .none

        case .propagateInvoiceDetail(let action):
            switch action {
            case .deleted(.success(_)):
                state.invoiceDetailState = nil
                return .none
            default:
                return .none
            }
        }
    }
    .presents(
        InvoiceDetailVM.reducer,
        state: \.invoiceDetailState,
        action: /InvoiceHistoryListVM.Action.propagateInvoiceDetail,
        environment: { _environment in
            InvoiceDetailVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension InvoiceHistoryListVM {
    enum Action: Equatable {
        case fetchHistoryList
        case refreshHistoryList
        case historyList(Result<[InvoiceHistory], AppError>)
        case presentInvoiceDetailView(Invoice)
        case popInvoiceDetailView

        case propagateInvoiceDetail(InvoiceDetailVM.Action)
    }

    struct State: Equatable {
        var isRefreshing: Bool = false
        var histories: [InvoiceHistory] = []
        var invoiceDetailState: InvoiceDetailVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
