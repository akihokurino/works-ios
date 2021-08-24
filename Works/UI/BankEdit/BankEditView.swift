import ComposableArchitecture
import SwiftUI

struct BankEditView: View {
    let store: Store<BankEditTCA.State, BankEditTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {}
                .navigationBarTitle("振込先", displayMode: .inline)
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
                    send: BankEditTCA.Action.isPresentedAlert
                )) {
                    Alert(title: Text(viewStore.alertText))
                }
        }
    }
}

struct BankEditView_Previews: PreviewProvider {
    static var previews: some View {
        BankEditView(store: .init(
            initialState: BankEditTCA.State(),
            reducer: .empty,
            environment: BankEditTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
