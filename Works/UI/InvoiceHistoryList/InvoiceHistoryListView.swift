import ComposableArchitecture
import SwiftUI

struct InvoiceHistoryListView: View {
    let store: Store<InvoiceHistoryListTCA.State, InvoiceHistoryListTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {}
                .background(Color.white)
                .navigationBarTitle("履歴", displayMode: .inline)
                .overlay(Group {
                    if viewStore.isLoading {
                        HUD(isLoading: Binding(
                            get: { viewStore.isLoading },
                            set: { _ in }
                        ))
                    }
                }, alignment: .center)
        }
    }
}

struct InvoiceHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceHistoryListView(store: .init(
            initialState: InvoiceHistoryListTCA.State(),
            reducer: .empty,
            environment: InvoiceHistoryListTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
