import Combine
import ComposableArchitecture
import Firebase

enum SupplierListTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .refresh:
            state.isRefreshing = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.me() }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierListTCA.Action.refreshed)
        case .refreshed(.success(let me)):
            state.isRefreshing = false
            state.me = me
            return .none
        case .refreshed(.failure(_)):
            state.isRefreshing = false
            return .none
        case .presentCreateView:
            state.crateState = SupplierCreateTCA.State()
            return .none
        case .popCreateView:
            state.crateState = nil
            return .none
        case .presentDetailView(let supplier):
            state.detailState = SupplierDetailTCA.State(supplier: supplier)
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
                    .map(SupplierListTCA.Action.refreshed)
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
                    .map(SupplierListTCA.Action.refreshed)
            default:
                return .none
            }
        }
    }
    .presents(
        SupplierCreateTCA.reducer,
        state: \.crateState,
        action: /SupplierListTCA.Action.propagateCreate,
        environment: { _environment in
            SupplierCreateTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        SupplierDetailTCA.reducer,
        state: \.detailState,
        action: /SupplierListTCA.Action.propagateDetail,
        environment: { _environment in
            SupplierDetailTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension SupplierListTCA {
    enum Action: Equatable {
        case refresh
        case refreshed(Result<Me, AppError>)
        case presentCreateView
        case popCreateView
        case presentDetailView(Supplier)
        case popDetailView

        case propagateCreate(SupplierCreateTCA.Action)
        case propagateDetail(SupplierDetailTCA.Action)
    }

    struct State: Equatable {
        var isRefreshing: Bool = false
        var me: Me

        var crateState: SupplierCreateTCA.State?
        var detailState: SupplierDetailTCA.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
