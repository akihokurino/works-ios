import ComposableArchitecture
import SwiftUI

struct InvoiceHistoryListView: View {
    let store: Store<InvoiceHistoryListTCA.State, InvoiceHistoryListTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                RefreshControl(isRefreshing: Binding(
                    get: { viewStore.isRefreshing },
                    set: { _ in }
                ), coordinateSpaceName: "RefreshControl", onRefresh: {
                    viewStore.send(.refreshHistoryList)
                })

                VStack(spacing: 15) {
                    ForEach(viewStore.histories, id: \.self) { history in
                        InvoiceHistoryCell(history: history) {
                            viewStore.send(.presentInvoiceDetailView(history.invoice))
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
            .coordinateSpace(name: "RefreshControl")
            .onAppear {
                viewStore.send(.fetchHistoryList)
            }
            .background(Color.white)
            .navigationBarTitle("履歴", displayMode: .inline)
        }
        .navigate(
            using: store.scope(
                state: \.invoiceDetailState,
                action: InvoiceHistoryListTCA.Action.propagateInvoiceDetail
            ),
            destination: InvoiceDetailView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popInvoiceDetailView)
            }
        )
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
