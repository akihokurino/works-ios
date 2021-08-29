import Combine
import ComposableArchitecture
import Firebase

enum SupplierListVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .refresh:
            state.isRefreshing = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.me() }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierListVM.Action.refreshed)
        case .refreshed(.success(let me)):
            state.isRefreshing = false
            state.me = me
            return .none
        case .refreshed(.failure(_)):
            state.isRefreshing = false
            return .none
        case .presentCreateView:
            state.crateState = SupplierCreateVM.State()
            return .none
        case .popCreateView:
            state.crateState = nil
            return .none
        case .presentDetailView(let supplier):
            state.detailState = SupplierDetailVM.State(supplier: supplier)
            return .none
        case .popDetailView:
            state.detailState = nil
            return .none

        case .propagateCreate(let action):
            switch action {
            case .back:
                state.crateState = nil
                return .none
            case .created(.success(_)):
                state.crateState = nil
                return GraphQLClient.shared.caller()
                    .subscribe(on: environment.backgroundQueue)
                    .flatMap { caller in caller.me() }
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(SupplierListVM.Action.refreshed)
            default:
                return .none
            }
        case .propagateDetail(let action):
            switch action {
            case .back:
                state.detailState = nil
                return .none
            case .deleted(.success(_)):
                state.detailState = nil
                return GraphQLClient.shared.caller()
                    .subscribe(on: environment.backgroundQueue)
                    .flatMap { caller in caller.me() }
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(SupplierListVM.Action.refreshed)
            default:
                return .none
            }
        }
    }
    .presents(
        SupplierCreateVM.reducer,
        state: \.crateState,
        action: /SupplierListVM.Action.propagateCreate,
        environment: { _environment in
            SupplierCreateVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        SupplierDetailVM.reducer,
        state: \.detailState,
        action: /SupplierListVM.Action.propagateDetail,
        environment: { _environment in
            SupplierDetailVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension SupplierListVM {
    enum Action: Equatable {
        case refresh
        case refreshed(Result<Me, AppError>)
        case presentCreateView
        case popCreateView
        case presentDetailView(Supplier)
        case popDetailView

        case propagateCreate(SupplierCreateVM.Action)
        case propagateDetail(SupplierDetailVM.Action)
    }

    struct State: Equatable {
        var isRefreshing: Bool = false
        var me: Me

        var crateState: SupplierCreateVM.State?
        var detailState: SupplierDetailVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
