//
//  SettingCore.swift
//  Works
//
//  Created by akiho on 2021/07/15.
//

import Combine
import ComposableArchitecture
import Firebase

enum SettingCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .signOut:
                state.isLoading = true
                try? Auth.auth().signOut()
                state.isLoading = false
                return .none
            }
        }
    )
}

extension SettingCore {
    enum Action: Equatable {
        case signOut
    }

    struct State: Equatable {
        var isLoading: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
