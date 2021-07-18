//
//  SupplierCreateCore.swift
//  Works
//
//  Created by akiho on 2021/07/18.
//

import Combine
import ComposableArchitecture
import Firebase

enum SupplierCreateCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { _, action, _ in
            switch action {
            case .back:
                return .none
            }
        }
    )
}

extension SupplierCreateCore {
    enum Action: Equatable {
        case back
    }

    struct State: Equatable {
        var isLoading: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
