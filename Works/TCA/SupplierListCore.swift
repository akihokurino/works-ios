//
//  SupplierListCore.swift
//  Works
//
//  Created by akiho on 2021/07/17.
//

import Combine
import ComposableArchitecture
import Firebase

enum SupplierListCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .refresh:
                state.isRefreshing = true
                return GraphQLClient.shared.caller()
                    .flatMap { caller in caller.me() }
                    .catchToEffect()
                    .map(SupplierListCore.Action.refreshed)
            case .refreshed(.success(let me)):
                state.isRefreshing = false
                state.me = me
                return .none
            case .refreshed(.failure(_)):
                state.isRefreshing = false
                return .none
            }
        }
    )
}

extension SupplierListCore {
    enum Action: Equatable {
        case refresh
        case refreshed(Result<Me, AppError>)
    }

    struct State: Equatable {
        var isRefreshing: Bool = false
        var me: Me
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
