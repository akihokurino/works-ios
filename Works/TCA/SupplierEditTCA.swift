import Combine
import ComposableArchitecture
import Firebase

struct UpdateSupplierParams: Equatable {
    let name: String
    let billingAmount: Int
    let endYm: String
    let subject: String
    let subjectTemplate: String
}

enum SupplierEditTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .back:
            return .none
        case .update(let params):
            state.isLoading = true
            let id = state.supplier.id
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in
                    caller.updateSupplier(
                        id: id,
                        name: params.name,
                        billingAmount: params.billingAmount,
                        endYm: params.endYm,
                        subject: params.subject,
                        subjectTemplate: params.subjectTemplate)
                }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SupplierEditTCA.Action.updated)
        case .updated(.success(_)):
            state.isLoading = false
            return .none
        case .updated(.failure(_)):
            state.isLoading = false
            return .none
        }
    }
}

extension SupplierEditTCA {
    enum Action: Equatable {
        case back
        case update(UpdateSupplierParams)
        case updated(Result<Supplier, AppError>)
    }

    struct State: Equatable {
        let supplier: Supplier
        var isLoading: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
