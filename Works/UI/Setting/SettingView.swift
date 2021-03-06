import ComposableArchitecture
import SwiftUI

struct SettingView: View {
    let store: Store<SettingVM.State, SettingVM.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Divider().background(Color.gray.opacity(0.5))
                    MenuButton(text: "振込先") {
                        viewStore.send(.presentBankEditView)
                    }
                    Divider().background(Color.gray.opacity(0.5))
                    MenuButton(text: "自社") {
                        viewStore.send(.presentSenderEditView)
                    }
                    Divider().background(Color.gray.opacity(0.5))
                    MenuLink(text: "Misoca接続") {
                        MisocaOAuthView(onLogin: { code in
                            viewStore.send(.connectMisoca(code))
                        }, onRefresh: {
                            viewStore.send(.refreshMisoca)
                        })
                    }
                    Divider().background(Color.gray.opacity(0.5))
                }

                Spacer().frame(height: 40)
                ActionButton(text: "ログアウト", background: .caution) {
                    viewStore.send(.signOut)
                }
                .padding()
            }
            .background(Color.white)
            .navigationBarTitle("設定", displayMode: .inline)
            .overlay(Group {
                if viewStore.isLoading {
                    HUD(isLoading: Binding(
                        get: { viewStore.isLoading },
                        set: { _ in }
                    ))
                }
            }, alignment: .center)
            .alert(isPresented: viewStore.binding(
                get: \.isPresentedAlert,
                send: SettingVM.Action.isPresentedAlert
            )) {
                Alert(title: Text(viewStore.alertText))
            }
        }
        .navigate(
            using: store.scope(
                state: \.bankEditState,
                action: SettingVM.Action.propagateBankEdit
            ),
            destination: BankEditView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popBankEditView)
            }
        )
        .navigate(
            using: store.scope(
                state: \.senderEditState,
                action: SettingVM.Action.propagateSenderEdit
            ),
            destination: SenderEditView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popSenderEditView)
            }
        )
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: .init(
            initialState: SettingVM.State(me: Me.mock),
            reducer: .empty,
            environment: SettingVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
