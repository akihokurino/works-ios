import Combine
import ComposableArchitecture
import Firebase

enum SupplierDetailVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .back:
            return .none
        case .presentEditView:
            state.editState = SupplierEditVM.State(supplier: state.supplier)
            return .none
        case .popEditView:
            state.editState = nil
            return .none
        case .presentInvoiceDetailView(let invoice):
            state.invoiceDetailState = InvoiceDetailVM.State(invoice: invoice)
            return .none
        case .popInvoiceDetailView:
            state.invoiceDetailState = nil
            return .none
        case .delete:
            state.isLoading = true
            let id = state.supplier.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.deleteSupplier(id: id) }
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailVM.Action.deleted)
        case .deleted(.success(_)):
            state.isLoading = false
            return .none
        case .deleted(.failure(_)):
            state.isLoading = false
            return .none
        case .initInvoiceList:
            state.page = 1
            state.hasNext = true
            state.invoices = []
            let page = state.page
            let supplierId = state.supplier.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId, page: page, limit: 20) }
                .map { $0.withRefresh(false) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailVM.Action.invoiceList)
        case .refreshInvoiceList:
            state.page = 1
            state.hasNext = true
            state.isRefreshing = true
            let page = state.page
            let supplierId = state.supplier.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId, page: page, limit: 20) }
                .map { $0.withRefresh(true) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailVM.Action.invoiceList)
        case .nextInvoiceList:
            if !state.hasNext || state.isNextLoading {
                return .none
            }
            
            state.isNextLoading = true
            state.page += 1
            let page = state.page
            let supplierId = state.supplier.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId, page: page, limit: 20) }
                .map { $0.withRefresh(false) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailVM.Action.invoiceList)
        case .invoiceList(.success(let result)):
            if result.isRefresh {
                state.invoices = result.paging.items
            } else {
                var current = state.invoices
                current.append(contentsOf: result.paging.items)
                state.invoices = current
            }

            state.isRefreshing = false
            state.isNextLoading = false
            state.hasNext = result.paging.hasNext
            return .none
        case .invoiceList(.failure(_)):
            state.isRefreshing = false
            state.isNextLoading = false
            return .none

        case .propagateEdit(let action):
            switch action {
            case .back:
                state.editState = nil
                return .none
            case .updated(.success(let supplier)):
                state.supplier = supplier
                state.editState = nil
                return .none
            default:
                return .none
            }
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
        SupplierEditVM.reducer,
        state: \.editState,
        action: /SupplierDetailVM.Action.propagateEdit,
        environment: { _environment in
            SupplierEditVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        InvoiceDetailVM.reducer,
        state: \.invoiceDetailState,
        action: /SupplierDetailVM.Action.propagateInvoiceDetail,
        environment: { _environment in
            InvoiceDetailVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension SupplierDetailVM {
    enum Action: Equatable {
        case back
        case presentEditView
        case popEditView
        case presentInvoiceDetailView(Invoice)
        case popInvoiceDetailView
        case delete
        case deleted(Result<Bool, AppError>)
        case initInvoiceList
        case refreshInvoiceList
        case nextInvoiceList
        case invoiceList(Result<PagingWithRefresh<Invoice>, AppError>)

        case propagateEdit(SupplierEditVM.Action)
        case propagateInvoiceDetail(InvoiceDetailVM.Action)
    }

    struct State: Equatable {
        var supplier: Supplier
        var invoices: [Invoice] = []
        var page: Int = 1
        var hasNext: Bool = true
        var isLoading: Bool = false
        var isRefreshing: Bool = false
        var isNextLoading: Bool = false

        var editState: SupplierEditVM.State?
        var invoiceDetailState: InvoiceDetailVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
