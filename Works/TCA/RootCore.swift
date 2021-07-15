//
//  RootCore.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import Combine
import ComposableArchitecture
import FirebaseAuth

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
                    state.authState = .alreadyLogin
                    state.settingState = SettingCore.State()
                } else {
                    state.authState = .shouldLogin
                    state.signInState = SignInCore.State()
                }

                return .none
            case .signIn(let action):
                switch action {
                case .verified(.success(let me)):
                    state.me = me
                    state.authState = .alreadyLogin
                    state.settingState = SettingCore.State()
                default:
                    break
                }
                return .none
            case .setting(let action):
                switch action {
                case .signOut:
                    state.me = nil
                    state.authState = .shouldLogin
                    state.signInState = SignInCore.State()
                }
                return .none
            }
        }
    )
}

extension RootCore {
    enum Action: Equatable {
        case onAppear
        case signIn(SignInCore.Action)
        case setting(SettingCore.Action)
    }

    struct State: Equatable {
        var me: Me?
        var authState: AuthState = .unknown
        var signInState: SignInCore.State?
        var settingState: SettingCore.State?
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
