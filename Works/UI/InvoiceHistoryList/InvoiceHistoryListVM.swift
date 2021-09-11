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
        case .initHistoryList:
            state.page = 1
            state.hasNext = true
            state.histories = []
            let page = state.page
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceHistoryList(page: page, limit: 20) }
                .map { $0.withRefresh(false) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceHistoryListVM.Action.historyList)
        case .refreshHistoryList:
            state.page = 1
            state.hasNext = true
            state.isRefreshing = true
            let page = state.page
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceHistoryList(page: page, limit: 20) }
                .map { $0.withRefresh(true) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceHistoryListVM.Action.historyList)
        case .nextHistoryList:
            if !state.hasNext || state.isNextLoading {
                return .none
            }
            
            state.isNextLoading = true
            state.page += 1
            let page = state.page
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceHistoryList(page: page, limit: 20) }
                .map { $0.withRefresh(false) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(InvoiceHistoryListVM.Action.historyList)
        case .historyList(.success(let result)):
            if result.isRefresh {
                state.histories = result.paging.items
            } else {
                var current = state.histories
                current.append(contentsOf: result.paging.items)
                state.histories = current
            }

            state.isRefreshing = false
            state.isNextLoading = false
            state.hasNext = result.paging.hasNext
            return .none
        case .historyList(.failure(_)):
            state.isRefreshing = false
            state.isNextLoading = false
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
        case initHistoryList
        case refreshHistoryList
        case nextHistoryList
        case historyList(Result<PagingWithRefresh<InvoiceHistory>, AppError>)
        case presentInvoiceDetailView(Invoice)
        case popInvoiceDetailView

        case propagateInvoiceDetail(InvoiceDetailVM.Action)
    }

    struct State: Equatable {
        var isRefreshing: Bool = false
        var histories: [InvoiceHistory] = []
        var page: Int = 1
        var hasNext: Bool = false
        var isNextLoading: Bool = false
        var invoiceDetailState: InvoiceDetailVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
