import Combine
import ComposableArchitecture
import Firebase

enum SupplierDetailTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .back:
            return .none
        case .presentEditView:
            state.editState = SupplierEditTCA.State()
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

        case .propagateEdit(let action):
            switch action {
            case .back:
                state.editState = nil
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

        case propagateEdit(SupplierEditTCA.Action)
    }

    struct State: Equatable {
        let supplier: Supplier
        var isLoading: Bool = false

        var editState: SupplierEditTCA.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
