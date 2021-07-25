import Combine
import ComposableArchitecture
import Firebase

enum SettingTCA {
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .signOut:
            try? Auth.auth().signOut()
            return .none
        case .connectMisoca(let code):
            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.connectMisoca(code: code) }
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SettingTCA.Action.connectedMisoca)
        case .refreshMisoca:
            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.refreshMisoca() }
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SettingTCA.Action.connectedMisoca)
        case .connectedMisoca(.success(_)):
            state.isPresentedAlert = true
            state.alertText = "Misocaとの同期に成功しました"
            state.isLoading = false
            return .none
        case .connectedMisoca(.failure(_)):
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

extension SettingTCA {
    enum Action: Equatable {
        case signOut
        case connectMisoca(String)
        case refreshMisoca
        case connectedMisoca(Result<Bool, AppError>)
        case isPresentedAlert(Bool)
    }

    struct State: Equatable {
        var isLoading: Bool = false
        var alertText: String = ""
        var isPresentedAlert: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
