import Combine
import ComposableArchitecture
import Firebase

enum SettingVM {
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
                .map(SettingVM.Action.connectedMisoca)
        case .refreshMisoca:
            state.isLoading = true
            return GraphQLClient.shared.caller()
                .subscribe(on: environment.backgroundQueue)
                .flatMap { caller in caller.refreshMisoca() }
                .map { _ in true }
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(SettingVM.Action.connectedMisoca)
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
        case .presentBankEditView:
            let bank = state.me.bank
            state.bankEditState = BankEditVM.State(bank: bank)
            return .none
        case .popBankEditView:
            state.bankEditState = nil
            return .none
        case .presentSenderEditView:
            let sender = state.me.sender
            state.senderEditState = SenderEditVM.State(sender: sender)
            return .none
        case .popSenderEditView:
            state.senderEditState = nil
            return .none

        case .propagateBankEdit(let action):
            switch action {
            case .back:
                state.bankEditState = nil
                return .none
            case .updated(.success(let bank)):
                state.me.bank = bank
                return .none
            case .deleted(.success(_)):
                state.me.bank = nil
                state.bankEditState = nil
                return .none
            default:
                return .none
            }
        case .propagateSenderEdit(let action):
            switch action {
            case .back:
                state.senderEditState = nil
                return .none
            case .updated(.success(let sender)):
                state.me.sender = sender
                return .none
            case .deleted(.success(_)):
                state.me.sender = nil
                state.senderEditState = nil
                return .none
            default:
                return .none
            }
        }
    }
    .presents(
        BankEditVM.reducer,
        state: \.bankEditState,
        action: /SettingVM.Action.propagateBankEdit,
        environment: { _environment in
            BankEditVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
    .presents(
        SenderEditVM.reducer,
        state: \.senderEditState,
        action: /SettingVM.Action.propagateSenderEdit,
        environment: { _environment in
            SenderEditVM.Environment(
                mainQueue: _environment.mainQueue,
                backgroundQueue: _environment.backgroundQueue
            )
        }
    )
}

extension SettingVM {
    enum Action: Equatable {
        case signOut
        case connectMisoca(String)
        case refreshMisoca
        case connectedMisoca(Result<Bool, AppError>)
        case isPresentedAlert(Bool)
        case presentBankEditView
        case popBankEditView
        case presentSenderEditView
        case popSenderEditView

        case propagateBankEdit(BankEditVM.Action)
        case propagateSenderEdit(SenderEditVM.Action)
    }

    struct State: Equatable {
        var isLoading: Bool = false
        var alertText: String = ""
        var isPresentedAlert: Bool = false
        var me: Me

        var bankEditState: BankEditVM.State?
        var senderEditState: SenderEditVM.State?
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
