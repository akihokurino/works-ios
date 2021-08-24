import Combine
import ComposableArchitecture
import Firebase

struct UpdateSenderParams: Equatable {
    let name: String
    let email: String
    let tel: String
    let postalCode: String
    let address: String
}

enum SenderEditTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .back:
            return .none
        case .update(let params):
            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in
                    caller.registerSender(
                        name: params.name,
                        email: params.email,
                        tel: params.tel,
                        postalCode: params.postalCode,
                        address: params.address)
                }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SenderEditTCA.Action.updated)
        case .updated(.success(_)):
            state.isPresentedAlert = true
            state.alertText = "自社情報を登録しました"
            state.isLoading = false
            return .none
        case .updated(.failure(_)):
            state.isLoading = false
            return .none
        case .delete:
            guard let sender = state.sender else {
                return .none
            }

            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in
                    caller.deleteSender(id: sender.id)
                }
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SenderEditTCA.Action.deleted)
        case .deleted(.success(_)):
            state.isLoading = false
            return .none
        case .deleted(.failure(_)):
            state.isLoading = false
            return .none
        case .isPresentedAlert(let isPresented):
            state.isPresentedAlert = isPresented
            if !isPresented {
                state.alertText = ""
            }
            return .none
        }
    }
}

extension SenderEditTCA {
    enum Action: Equatable {
        case back
        case update(UpdateSenderParams)
        case updated(Result<Sender, AppError>)
        case delete
        case deleted(Result<Bool, AppError>)
        case isPresentedAlert(Bool)
    }

    struct State: Equatable {
        var sender: Sender?
        var isLoading: Bool = false
        var alertText: String = ""
        var isPresentedAlert: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
