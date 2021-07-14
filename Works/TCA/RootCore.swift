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
        Reducer { state, action, _ in
            switch action {
            case .onAppear:
                if let me = Auth.auth().currentUser {
                    state.authState = .alreadyLogin
                } else {
                    state.authState = .shouldLogin
                    state.signInState = SignInCore.State()
                }

                return .none
            case .signIn(let action):
                return .none
            }
        }
    )
}

extension RootCore {
    enum Action: Equatable {
        case onAppear
        case signIn(SignInCore.Action)
    }

    struct State: Equatable {
        var authState: AuthState = .unknown
        var signInState: SignInCore.State?
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
