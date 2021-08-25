import ComposableArchitecture
import SwiftUI

struct InvoiceHistoryListView: View {
    let store: Store<InvoiceHistoryListTCA.State, InvoiceHistoryListTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            InvoiceHistoryPagerView { pagerType in
                WithViewStore(store) { viewStore in
                    ScrollView {
                        RefreshControl(isRefreshing: Binding(
                            get: { viewStore.isRefreshing },
                            set: { _ in }
                        ), coordinateSpaceName: RefreshControlKey, onRefresh: {
                            viewStore.send(.refreshHistoryList)
                        })

                        if pagerType == .normal {
                            VStack(spacing: 15) {
                                ForEach(viewStore.histories, id: \.self) { history in
                                    InvoiceHistoryCell(history: history) {
                                        viewStore.send(.presentInvoiceDetailView(history.invoice))
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                        } else {
                            VStack(spacing: 15) {
                                ForEach(viewStore.histories, id: \.self) { history in
                                    InvoiceHistorySimpleCell(history: history) {
                                        viewStore.send(.presentInvoiceDetailView(history.invoice))
                                    }
                                }
                            }
                            .padding(.top, 15)
                        }
                    }
                    .coordinateSpace(name: RefreshControlKey)
                }
            }
            .onAppear {
                viewStore.send(.fetchHistoryList)
            }
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
        .background(Color.white)
        .navigationBarTitle("履歴", displayMode: .inline)
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
