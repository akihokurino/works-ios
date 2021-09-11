import ComposableArchitecture
import SwiftUI

struct InvoiceHistoryListView: View {
    let store: Store<InvoiceHistoryListVM.State, InvoiceHistoryListVM.Action>

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

                        if viewStore.hasNext && viewStore.histories.count > 0 {
                            Button(action: {
                                viewStore.send(.nextHistoryList)
                            }) {
                                HStack {
                                    Spacer()
                                    Text("次の20件を表示する")
                                    Spacer()
                                }
                            }
                            .padding(.top, 15)
                            .padding(.bottom, 30)
                        }

                        if viewStore.hasNext && viewStore.histories.count == 0 {
                            ProgressView()
                                .padding(.top, 15)
                                .padding(.bottom, 30)
                        }
                    }
                    .coordinateSpace(name: RefreshControlKey)
                }
            }
            .onAppear {
                viewStore.send(.initHistoryList)
            }
        }
        .navigate(
            using: store.scope(
                state: \.invoiceDetailState,
                action: InvoiceHistoryListVM.Action.propagateInvoiceDetail
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
            initialState: InvoiceHistoryListVM.State(),
            reducer: .empty,
            environment: InvoiceHistoryListVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
