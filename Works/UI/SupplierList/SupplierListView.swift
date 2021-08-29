import ComposableArchitecture
import SwiftUI

struct SupplierListView: View {
    let store: Store<SupplierListVM.State, SupplierListVM.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                RefreshControl(isRefreshing: Binding(
                    get: { viewStore.isRefreshing },
                    set: { _ in }
                ), coordinateSpaceName: RefreshControlKey, onRefresh: {
                    viewStore.send(.refresh)
                })

                VStack {
                    Text("月毎の合計額（税込）")
                        .foregroundColor(Color.black)
                        .font(Font.system(size: 20.0))
                    Text("\(viewStore.me.totalAmountInMonthly)円")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(Font.system(size: 40.0))
                }
                .padding(.top, 15)

                VStack(spacing: 15) {
                    ForEach(viewStore.me.suppliers, id: \.self) { supplier in
                        SupplierCell(supplier: supplier) {
                            viewStore.send(.presentDetailView(supplier))
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
            }
            .coordinateSpace(name: RefreshControlKey)
            .navigationBarTitle("取引先", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    viewStore.send(.presentCreateView)
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 5)
                        .foregroundColor(Color.blue)
                }
            )
        }
        .navigate(
            using: store.scope(
                state: \.crateState,
                action: SupplierListVM.Action.propagateCreate
            ),
            destination: SupplierCreateView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popCreateView)
            }
        )
        .navigate(
            using: store.scope(
                state: \.detailState,
                action: SupplierListVM.Action.propagateDetail
            ),
            destination: SupplierDetailView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popDetailView)
            }
        )
    }
}

struct SupplierListView_Previews: PreviewProvider {
    static var previews: some View {
        SupplierListView(store: .init(
            initialState: SupplierListVM.State(me: Me.mock),
            reducer: .empty,
            environment: SupplierListVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
