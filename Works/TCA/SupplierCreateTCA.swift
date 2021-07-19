//
//  SupplierCreateCore.swift
//  Works
//
//  Created by akiho on 2021/07/18.
//

import Combine
import ComposableArchitecture
import Firebase

enum SupplierCreateTCA {
    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .back:
            return .none
        }
    }
}

extension SupplierCreateTCA {
    enum Action: Equatable {
        case back
    }

    struct State: Equatable {
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
