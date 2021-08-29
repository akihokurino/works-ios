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
        case .fetchInvoiceList:
            let supplierId = state.supplier.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailVM.Action.invoiceList)
        case .refreshInvoiceList:
            let supplierId = state.supplier.id
            state.isRefreshing = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.getInvoiceList(supplierId: supplierId) }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierDetailVM.Action.invoiceList)
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
        case fetchInvoiceList
        case refreshInvoiceList
        case invoiceList(Result<[Invoice], AppError>)

        case propagateEdit(SupplierEditVM.Action)
        case propagateInvoiceDetail(InvoiceDetailVM.Action)
    }

    struct State: Equatable {
        var supplier: Supplier
        var invoices: [Invoice] = []
        var isLoading: Bool = false
        var isRefreshing: Bool = false

        var editState: SupplierEditVM.State?
        var invoiceDetailState: InvoiceDetailVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
