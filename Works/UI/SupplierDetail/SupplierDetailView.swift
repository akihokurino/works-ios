import ComposableArchitecture
import SwiftUI

struct SupplierDetailView: View {
    let store: Store<SupplierDetailTCA.State, SupplierDetailTCA.Action>

    @State private var isShowActionSheet = false

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 10)
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
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding()

                VStack(spacing: 15) {
                    ForEach(viewStore.invoices, id: \.self) { invoice in
                        InvoiceCell(invoice: invoice) {
                            viewStore.send(.presentInvoiceDetailView(invoice))
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                viewStore.send(.fetchInvoiceList)
            }
            .navigationBarTitle(viewStore.supplier.name, displayMode: .inline)
//            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                //                leading: Button(action: {
//                    viewStore.send(.back)
//                }) {
//                    Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
//                },
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
                action: SupplierDetailTCA.Action.propagateEdit
            ),
            destination: SupplierEditView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popEditView)
            }
        )
        .navigate(
            using: store.scope(
                state: \.invoiceDetailState,
                action: SupplierDetailTCA.Action.propagateInvoiceDetail
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
            initialState: SupplierDetailTCA.State(supplier: Supplier.mock),
            reducer: .empty,
            environment: SupplierDetailTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
