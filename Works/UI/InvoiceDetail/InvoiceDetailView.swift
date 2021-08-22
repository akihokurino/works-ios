import ComposableArchitecture
import SwiftUI

struct InvoiceDetailView: View {
    let store: Store<InvoiceDetailTCA.State, InvoiceDetailTCA.Action>

    @State private var isShowActionSheet = false

    var body: some View {
        WithViewStore(store) { viewStore in
            PDFKitView(data: viewStore.pdf)
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .overlay(Group {
                    if viewStore.isLoading {
                        HUD(isLoading: Binding(
                            get: { viewStore.isLoading },
                            set: { _ in }
                        ))
                    }
                }, alignment: .center)
                .navigationBarTitle("請求書", displayMode: .inline)
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
                .actionSheet(isPresented: $isShowActionSheet) {
                    ActionSheet(title: Text("選択してください"), buttons:
                        [
                            .destructive(Text("削除")) {
                                viewStore.send(.delete)
                            },
                            .cancel(Text("閉じる"))
                        ])
                }
        }
    }
}

struct InvoiceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceDetailView(store: .init(
            initialState: InvoiceDetailTCA.State(invoice: Invoice.mock),
            reducer: .empty,
            environment: InvoiceDetailTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
