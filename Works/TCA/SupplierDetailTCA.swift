import Combine
import ComposableArchitecture
import Firebase

enum SupplierDetailTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .back:
            return .none
        case .presentEditView:
            state.editState = SupplierEditTCA.State(supplier: state.supplier)
            return .none
        case .popEditView:
            state.editState = nil
            return .none
        case .delete:
            state.isLoading = true
            let id = state.supplier.id
            return GraphQLClient.shared.caller()
                .flatMap { caller in caller.deleteSupplier(id: id) }
                .map { _ in true }
                .catchToEffect()
                .map(SupplierDetailTCA.Action.deleted)
        case .deleted(.success(_)):
            return .none
        case .deleted(.failure(_)):
            return .none
        case .fetchInvoiceList:
            let supplierId = state.supplier.id
            return GraphQLClient.shared.caller()
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId) }
                .catchToEffect()
                .map(SupplierDetailTCA.Action.invoiceList)
        case .refreshInvoiceList:
            let supplierId = state.supplier.id
            state.isRefreshing = true
            return GraphQLClient.shared.caller()
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId) }
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
}

extension SupplierDetailTCA {
    enum Action: Equatable {
        case back
        case presentEditView
        case popEditView
        case delete
        case deleted(Result<Bool, AppError>)
        case fetchInvoiceList
        case refreshInvoiceList
        case invoiceList(Result<[Invoice], AppError>)

        case propagateEdit(SupplierEditTCA.Action)
    }

    struct State: Equatable {
        var supplier: Supplier
        var invoices: [Invoice] = []
        var isLoading: Bool = false
        var isRefreshing: Bool = false

        var editState: SupplierEditTCA.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
