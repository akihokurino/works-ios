import ComposableArchitecture
import SwiftUI

struct SettingView: View {
    let store: Store<SettingTCA.State, SettingTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Divider()
                    Menu(text: "振込先") {}
                    Divider()
                    Menu(text: "稼働状況") {}
                    Divider()
                    Menu(text: "Misoca接続") {
                        MisocaOAuthView(onLogin: { code in
                            viewStore.send(.connectMisoca(code))
                        }, onRefresh: {
                            viewStore.send(.refreshMisoca)
                        })
                    }
                    Divider()
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
                send: SettingTCA.Action.isPresentedAlert
            )) {
                Alert(title: Text(viewStore.alertText))
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: .init(
            initialState: SettingTCA.State(),
            reducer: .empty,
            environment: SettingTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
