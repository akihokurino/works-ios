import Combine
import ComposableArchitecture
import Firebase

enum SupplierDetailTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .back:
            return .none
        case .presentEditView:
            state.editState = SupplierEditTCA.State(supplier: state.supplier)
            return .none
        case .popEditView:
            state.editState = nil
            return .none
        case .presentInvoiceDetailView(let invoice):
            state.invoiceDetailState = InvoiceDetailTCA.State(invoice: invoice)
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
                .map(SupplierDetailTCA.Action.deleted)
        case .deleted(.success(_)):
            state.isLoading = false
            return .none
        case .deleted(.failure(_)):
            state.isLoading = false
            return .none
        case .fetchInvoiceList:
            let supplierId = state.supplier.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailTCA.Action.invoiceList)
        case .refreshInvoiceList:
            let supplierId = state.supplier.id
            state.isRefreshing = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailTCA.Action.invoiceList)
        case .invoiceList(.success(let items)):
            state.isRefreshing = false
            state.invoices = items
            return .none
        case .invoiceList(.failure(_)):
            state.isRefreshing = false
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
        SupplierEditTCA.reducer,
        state: \.editState,
        action: /SupplierDetailTCA.Action.propagateEdit,
        environment: { _environment in
            SupplierEditTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        InvoiceDetailTCA.reducer,
        state: \.invoiceDetailState,
        action: /SupplierDetailTCA.Action.propagateInvoiceDetail,
        environment: { _environment in
            InvoiceDetailTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension SupplierDetailTCA {
    enum Action: Equatable {
        case back
        case presentEditView
        case popEditView
        case presentInvoiceDetailView(Invoice)
        case popInvoiceDetailView
        case delete
        case deleted(Result<Bool, AppError>)
        case fetchInvoiceList
        case refreshInvoiceList
        case invoiceList(Result<[Invoice], AppError>)

        case propagateEdit(SupplierEditTCA.Action)
        case propagateInvoiceDetail(InvoiceDetailTCA.Action)
    }

    struct State: Equatable {
        var supplier: Supplier
        var invoices: [Invoice] = []
        var isLoading: Bool = false
        var isRefreshing: Bool = false

        var editState: SupplierEditTCA.State?
        var invoiceDetailState: InvoiceDetailTCA.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
