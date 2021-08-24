import ComposableArchitecture
import SwiftUI

struct SenderEditView: View {
    let store: Store<SenderEditTCA.State, SenderEditTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {}
                .navigationBarTitle("自社", displayMode: .inline)
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
                    send: SenderEditTCA.Action.isPresentedAlert
                )) {
                    Alert(title: Text(viewStore.alertText))
                }
        }
    }
}

struct SenderEditView_Previews: PreviewProvider {
    static var previews: some View {
        SenderEditView(store: .init(
            initialState: SenderEditTCA.State(),
            reducer: .empty,
            environment: SenderEditTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
