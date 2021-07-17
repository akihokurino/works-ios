//
//  RootCore.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import Combine
import ComposableArchitecture
import Firebase

enum RootCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        SignInCore.reducer.optional().pullback(
            state: \RootCore.State.signInState,
            action: /RootCore.Action.signIn,
            environment: { _environment in
                SignInCore.Environment(
                    mainQueue: _environment.mainQueue,
                    backgroundQueue: _environment.backgroundQueue
                )
            }
        ),
        SupplierListCore.reducer.optional().pullback(
            state: \RootCore.State.supplierListState,
            action: /RootCore.Action.supplierList,
            environment: { _environment in
                SupplierListCore.Environment(
                    mainQueue: _environment.mainQueue,
                    backgroundQueue: _environment.backgroundQueue
                )
            }
        ),
        SettingCore.reducer.optional().pullback(
            state: \RootCore.State.settingState,
            action: /RootCore.Action.setting,
            environment: { _environment in
                SettingCore.Environment(
                    mainQueue: _environment.mainQueue,
                    backgroundQueue: _environment.backgroundQueue
                )
            }
        ),
        Reducer { state, action, _ in
            switch action {
            case .onAppear:
                if let me = Auth.auth().currentUser {
                    state.isLoading = true
                    return GraphQLClient.shared.caller()
                        .flatMap { caller in caller.me() }
                        .catchToEffect()
                        .map(RootCore.Action.me)
                } else {
                    state.setSignOutState()
                    return .none
                }
            case .signIn(let action):
                switch action {
                case .verified(.success(let me)):
                    state.setSignInState(me: me)
                default:
                    break
                }
                return .none
            case .supplierList(let action):
                switch action {
                case .refreshed(.success(let me)):
                    state.me = me
                default:
                    break
                }
                return .none
            case .setting(let action):
                switch action {
                case .signOut:
                    state.setSignOutState()
                }
                return .none
            case .me(.success(let me)):
                state.isLoading = false
                state.setSignInState(me: me)
                return .none
            case .me(.failure(_)):
                return .none
            }
        }
    )
}

extension RootCore {
    enum Action: Equatable {
        case onAppear
        case signIn(SignInCore.Action)
        case supplierList(SupplierListCore.Action)
        case setting(SettingCore.Action)
        case me(Result<Me, AppError>)
    }

    struct State: Equatable {
        var isLoading: Bool = false
        var me: Me?
        var authState: AuthState = .unknown
        var signInState: SignInCore.State?
        var supplierListState: SupplierListCore.State?
        var settingState: SettingCore.State?

        mutating func setSignInState(me: Me) {
            self.me = me
            self.authState = .alreadyLogin
            self.signInState = nil
            self.supplierListState = SupplierListCore.State(me: me)
            self.settingState = SettingCore.State()
        }

        mutating func setSignOutState() {
            self.me = nil
            self.authState = .shouldLogin
            self.signInState = SignInCore.State()
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
