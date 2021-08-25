import Combine
import ComposableArchitecture
import Firebase

struct RegisterBankParams: Equatable {
    let name: String
    let code: String
    let accountType: GraphQL.GraphQLBankAccountType
    let accountNumber: String
}

enum BankEditTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .back:
            return .none
        case .update(let params):
            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in
                    caller.registerBank(
                        name: params.name,
                        code: params.code,
                        accountType: params.accountType,
                        accountNumber: params.accountNumber)
                }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(BankEditTCA.Action.updated)
        case .updated(.success(_)):
            state.isPresentedAlert = true
            state.alertText = "振込先情報を登録しました"
            state.isLoading = false
            return .none
        case .updated(.failure(_)):
            state.isLoading = false
            return .none
        case .delete:
            guard let bank = state.bank else {
                return .none
            }

            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in
                    caller.deleteBank(id: bank.id)
                }
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(BankEditTCA.Action.deleted)
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

extension BankEditTCA {
    enum Action: Equatable {
        case back
        case update(RegisterBankParams)
        case updated(Result<Bank, AppError>)
        case delete
        case deleted(Result<Bool, AppError>)
        case isPresentedAlert(Bool)
    }

    struct State: Equatable {
        var bank: Bank?
        var isLoading: Bool = false
        var alertText: String = ""
        var isPresentedAlert: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
