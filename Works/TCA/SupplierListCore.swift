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
        SupplierCreateCore.reducer.optional().pullback(
            state: \SupplierListCore.State.crateState,
            action: /SupplierListCore.Action.propagateCreate,
            environment: { _environment in
                SupplierCreateCore.Environment(
                    mainQueue: _environment.mainQueue,
                    backgroundQueue: _environment.backgroundQueue
                )
            }
        ),
        SupplierDetailCore.reducer.optional().pullback(
            state: \SupplierListCore.State.detailState,
            action: /SupplierListCore.Action.propagateDetail,
            environment: { _environment in
                SupplierDetailCore.Environment(
                    mainQueue: _environment.mainQueue,
                    backgroundQueue: _environment.backgroundQueue
                )
            }
        ),
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
            case .presentCreateView:
                state.crateState = SupplierCreateCore.State()
                return .none
            case .presentDetailView(let supplier):
                state.detailState = SupplierDetailCore.State(supplier: supplier)
                return .none
                
            case .propagateCreate(let action):
                switch action {
                case .back:
                    state.crateState = nil
                    return .none
                }
            case .propagateDetail(let action):
                switch action {
                case .back:
                    state.detailState = nil
                    return .none
                case .deleted(.success(_)):
                    state.detailState = nil
                    return GraphQLClient.shared.caller()
                        .flatMap { caller in caller.me() }
                        .catchToEffect()
                        .map(SupplierListCore.Action.refreshed)
                default:
                    return .none
                }
            }
        }
    )
}

extension SupplierListCore {
    enum Action: Equatable {
        case refresh
        case refreshed(Result<Me, AppError>)
        case presentCreateView
        case presentDetailView(Supplier)

        case propagateCreate(SupplierCreateCore.Action)
        case propagateDetail(SupplierDetailCore.Action)
    }

    struct State: Equatable {
        var isRefreshing: Bool = false
        var me: Me

        var crateState: SupplierCreateCore.State?
        var detailState: SupplierDetailCore.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
