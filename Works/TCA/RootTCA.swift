import Combine
import ComposableArchitecture
import Firebase

enum RootTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .onAppear:
            if let me = Auth.auth().currentUser {
                state.isLoading = true
                return GraphQLClient.shared.caller()
                    .flatMap { caller in caller.me() }
                    .catchToEffect()
                    .map(RootTCA.Action.me)
            } else {
                state.setSignOutState()
                return .none
            }
        case .me(.success(let me)):
            state.isLoading = false
            state.setSignInState(me: me)
            return .none
        case .me(.failure(_)):
            return .none

        case .propagateSignIn(let action):
            switch action {
            case .verified(.success(let me)):
                state.setSignInState(me: me)
                return .none
            default:
                return .none
            }
        case .propagateSupplierList(let action):
            switch action {
            case .refreshed(.success(let me)):
                state.me = me
                return .none
            default:
                return .none
            }
        case .propagateSetting(let action):
            switch action {
            case .signOut:
                state.setSignOutState()
                return .none
            }
        }
    }
    .presents(
        SignInTCA.reducer,
        state: \.signInState,
        action: /RootTCA.Action.propagateSignIn,
        environment: { _environment in
            SignInTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        SupplierListTCA.reducer,
        state: \.supplierListState,
        action: /RootTCA.Action.propagateSupplierList,
        environment: { _environment in
            SupplierListTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        SettingTCA.reducer,
        state: \.settingState,
        action: /RootTCA.Action.propagateSetting,
        environment: { _environment in
            SettingTCA.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension RootTCA {
    enum Action: Equatable {
        case onAppear
        case me(Result<Me, AppError>)

        case propagateSignIn(SignInTCA.Action)
        case propagateSupplierList(SupplierListTCA.Action)
        case propagateSetting(SettingTCA.Action)
    }

    struct State: Equatable {
        var isLoading: Bool = false
        var me: Me?
        var authState: AuthState = .unknown

        var signInState: SignInTCA.State?
        var supplierListState: SupplierListTCA.State?
        var settingState: SettingTCA.State?

        mutating func setSignInState(me: Me) {
            self.me = me
            self.authState = .alreadyLogin
            self.signInState = nil
            self.supplierListState = SupplierListTCA.State(me: me)
            self.settingState = SettingTCA.State()
        }

        mutating func setSignOutState() {
            self.me = nil
            self.authState = .shouldLogin
            self.signInState = SignInTCA.State()
            self.supplierListState = nil
            self.settingState = nil
        }
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}

enum AuthState {
    case unknown
    case alreadyLogin
    case shouldLogin
}
