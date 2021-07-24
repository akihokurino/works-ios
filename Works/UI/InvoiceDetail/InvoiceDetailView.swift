import ComposableArchitecture
import SwiftUI

struct InvoiceDetailView: View {
    let store: Store<InvoiceDetailTCA.State, InvoiceDetailTCA.Action>

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
