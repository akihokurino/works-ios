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
                }

                Spacer().frame(height: 40)
                ActionButton(text: "ログアウト", background: .caution) {
                    viewStore.send(.signOut)
                }
                .padding()
            }
            .background(Color.white)
            .navigationBarTitle("設定", displayMode: .inline)
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
