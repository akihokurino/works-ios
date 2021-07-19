//
//  RootTCA.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import Combine
import ComposableArchitecture
import Firebase

enum RootTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .propagateSignIn:
            return .none
        case .propagateSupplierList:
            return .none
        case .propagateSetting:
            return .none
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
        case propagateSignIn(SignInTCA.Action)
        case propagateSupplierList(SupplierListTCA.Action)
        case propagateSetting(SettingTCA.Action)
    }

    struct State: Equatable {
        var signInState: SignInTCA.State?
        var supplierListState: SupplierListTCA.State?
        var settingState: SettingTCA.State?
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
