//
//  SettingCore.swift
//  Works
//
//  Created by akiho on 2021/07/15.
//

import Combine
import ComposableArchitecture
import Firebase

enum SettingTCA {
    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .signOut:
            try? Auth.auth().signOut()
            return .none
        }
    }
}

extension SettingTCA {
    enum Action: Equatable {
        case signOut
    }

    struct State: Equatable {}

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
