import Combine
import ComposableArchitecture
import Firebase

enum RootVM {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .onAppear:
            if let me = Auth.auth().currentUser {
                state.isLoading = true
                return GraphQLClient.shared.caller()
                    .subscribe(on: environment.backgroundQueue)
                    .flatMap { caller in caller.me() }
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(RootVM.Action.me)
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
        case .propagateInvoiceHistoryList(let action):
            switch action {
            default:
                return .none
            }
        case .propagateSetting(let action):
            switch action {
            case .signOut:
                state.setSignOutState()
                return .none
            default:
                return .none
            }
        }
    }
    .presents(
        SignInVM.reducer,
        state: \.signInState,
        action: /RootVM.Action.propagateSignIn,
        environment: { _environment in
            SignInVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        SupplierListVM.reducer,
        state: \.supplierListState,
        action: /RootVM.Action.propagateSupplierList,
        environment: { _environment in
            SupplierListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        InvoiceHistoryListVM.reducer,
        state: \.invoiceHistoryListState,
        action: /RootVM.Action.propagateInvoiceHistoryList,
        environment: { _environment in
            InvoiceHistoryListVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        SettingVM.reducer,
        state: \.settingState,
        action: /RootVM.Action.propagateSetting,
        environment: { _environment in
            SettingVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension RootVM {
    enum Action: Equatable {
        case onAppear
        case me(Result<Me, AppError>)

        case propagateSignIn(SignInVM.Action)
        case propagateSupplierList(SupplierListVM.Action)
        case propagateInvoiceHistoryList(InvoiceHistoryListVM.Action)
        case propagateSetting(SettingVM.Action)
    }

    struct State: Equatable {
        var isLoading: Bool = false
        var me: Me?
        var authState: AuthState = .unknown

        var signInState: SignInVM.State?
        var supplierListState: SupplierListVM.State?
        var invoiceHistoryListState: InvoiceHistoryListVM.State?
        var settingState: SettingVM.State?

        mutating func setSignInState(me: Me) {
            self.me = me
            self.authState = .alreadyLogin
            self.signInState = nil
            self.supplierListState = SupplierListVM.State(me: me)
            self.invoiceHistoryListState = InvoiceHistoryListVM.State()
            self.settingState = SettingVM.State(me: me)
        }

        mutating func setSignOutState() {
            self.me = nil
            self.authState = .shouldLogin
            self.signInState = SignInVM.State()
            self.supplierListState = nil
            self.invoiceHistoryListState = nil
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
