import ComposableArchitecture
import SwiftUI

struct SettingView: View {
    let store: Store<SettingTCA.State, SettingTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Section(
                    footer: ActionButton(text: "ログアウト", background: .caution) {
                        viewStore.send(.signOut)
                    }
                    .padding(.vertical, 60)
                    .padding(.horizontal, 0)
                ) {
                    Menu(text: "振込先") {}.frame(height: 40)
                    Menu(text: "稼働状況") {}.frame(height: 40)
                }
            }
            .background(Color.white)
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("設定", displayMode: .inline)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: .init(
            initialState: SettingTCA.State(),
            reducer: SettingTCA.reducer,
            environment: SettingTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
