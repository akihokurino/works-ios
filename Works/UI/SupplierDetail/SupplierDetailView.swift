import ComposableArchitecture
import SwiftUI

struct SupplierDetailView: View {
    let store: Store<SupplierDetailVM.State, SupplierDetailVM.Action>

    @State private var isShowActionSheet = false

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                RefreshControl(isRefreshing: Binding(
                    get: { viewStore.isRefreshing },
                    set: { _ in }
                ), coordinateSpaceName: RefreshControlKey, onRefresh: {
                    viewStore.send(.refreshInvoiceList)
                })

                VStack(alignment: .leading) {
                    HStack {
                        Text("請求タイミング")
                            .foregroundColor(Color.gray)
                            .font(.body)
                            .frame(width: 150, alignment: .leading)
                        Text(viewStore.supplier.billingTypeText)
                            .foregroundColor(viewStore.supplier.billingType == .monthly ? Color.green : Color.orange)
                            .font(Font.system(size: 20.0))
                            .fontWeight(.bold)
                    }

                    Spacer().frame(height: 15)
                    Divider().background(Color.gray)
                    Spacer().frame(height: 15)

                    if viewStore.supplier.billingType == GraphQL.GraphQLBillingType.oneTime {
                        Group {
                            HStack {
                                Text("契約終了月")
                                    .foregroundColor(Color.gray)
                                    .font(.body)
                                    .frame(width: 150, alignment: .leading)
                                Text(viewStore.supplier.endYmString)
                                    .foregroundColor(Color.black)
                                    .font(Font.system(size: 20.0))
                            }

                            Spacer().frame(height: 15)
                            Divider().background(Color.gray)
                            Spacer().frame(height: 15)
                        }
                    }

                    HStack {
                        Text("請求額（税込）")
                            .foregroundColor(Color.gray)
                            .font(.body)
                            .frame(width: 150, alignment: .leading)
                        Text("\(viewStore.supplier.billingAmountIncludeTax)円")
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 20.0))
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)

                VStack(spacing: 15) {
                    ForEach(viewStore.invoices, id: \.self) { invoice in
                        InvoiceCell(invoice: invoice) {
                            viewStore.send(.presentInvoiceDetailView(invoice))
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)

                if viewStore.hasNext && viewStore.invoices.count > 0 {
                    Button(action: {
                        viewStore.send(.nextInvoiceList)
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

                if viewStore.hasNext && viewStore.invoices.count == 0 {
                    ProgressView()
                        .padding(.top, 15)
                        .padding(.bottom, 30)
                }
            }
            .coordinateSpace(name: RefreshControlKey)
            .onAppear {
                if viewStore.invoices.count == 0 {
                    viewStore.send(.initInvoiceList)
                }
            }
            .navigationBarTitle(viewStore.supplier.name, displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    self.isShowActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .padding(.vertical, 5)
                        .foregroundColor(Color.blue)
                }
            )
            .overlay(Group {
                if viewStore.isLoading {
                    HUD(isLoading: Binding(
                        get: { viewStore.isLoading },
                        set: { _ in }
                    ))
                }
            }, alignment: .center)
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(title: Text("選択してください"), buttons:
                    [
                        .default(Text("編集")) {
                            viewStore.send(.presentEditView)
                        },
                        .destructive(Text("削除")) {
                            viewStore.send(.delete)
                        },
                        .cancel(Text("閉じる"))
                    ])
            }
        }
        .navigate(
            using: store.scope(
                state: \.editState,
                action: SupplierDetailVM.Action.propagateEdit
            ),
            destination: SupplierEditView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popEditView)
            }
        )
        .navigate(
            using: store.scope(
                state: \.invoiceDetailState,
                action: SupplierDetailVM.Action.propagateInvoiceDetail
            ),
            destination: InvoiceDetailView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popInvoiceDetailView)
            }
        )
    }
}

struct SupplierDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SupplierDetailView(store: .init(
            initialState: SupplierDetailVM.State(supplier: Supplier.mock),
            reducer: .empty,
            environment: SupplierDetailVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
