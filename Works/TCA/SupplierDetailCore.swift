//
//  SupplierDetailCore.swift
//  Works
//
//  Created by akiho on 2021/07/18.
//

import Combine
import ComposableArchitecture
import Firebase

enum SupplierDetailCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        SupplierEditCore.reducer.optional().pullback(
            state: \SupplierDetailCore.State.editState,
            action: /SupplierDetailCore.Action.propagateEdit,
            environment: { _environment in
                SupplierEditCore.Environment(
                    mainQueue: _environment.mainQueue,
                    backgroundQueue: _environment.backgroundQueue
                )
            }
        ),
        Reducer { state, action, _ in
            switch action {
            case .back:
                return .none
            case .presentEditView:
                state.editState = SupplierEditCore.State()
                return .none
            case .delete:
                state.isLoading = true
                let id = state.supplier.id
                return GraphQLClient.shared.caller()
                    .flatMap { caller in caller.deleteSupplier(id: id) }
                    .map { _ in true }
                    .catchToEffect()
                    .map(SupplierDetailCore.Action.deleted)
            case .deleted(.success(_)):
                return .none
            case .deleted(.failure(_)):
                return .none

            case .propagateEdit(let action):
                switch action {
                case .back:
                    state.editState = nil
                    return .none
                }
            }
        }
    )
}

extension SupplierDetailCore {
    enum Action: Equatable {
        case presentEditView
        case delete
        case deleted(Result<Bool, AppError>)
        case back

        case propagateEdit(SupplierEditCore.Action)
    }

    struct State: Equatable {
        let supplier: Supplier
        var isLoading: Bool = false

        var editState: SupplierEditCore.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
