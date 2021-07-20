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
                        Text("支払いタイミング")
                            .foregroundColor(Color.gray)
                            .font(.body)
                            .frame(width: 150, alignment: .leading)
                        Text(viewStore.supplier.billingTypeText)
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 20.0))
                    }
                    
                    Spacer().frame(height: 15)
                    Divider().background(Color.gray)
                    Spacer().frame(height: 15)
                    
                    HStack {
                        Text("支払い額")
                            .foregroundColor(Color.gray)
                            .font(.body)
                            .frame(width: 150, alignment: .leading)
                        Text("\(viewStore.supplier.billingAmount)円")
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 20.0))
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
                .navigationBarTitle(viewStore.supplier.name, displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        viewStore.send(.back)
                    }) {
                        Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
                    },
                    trailing: Button(action: {
                        self.isShowActionSheet = true
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .padding(.vertical, 5)
                            .foregroundColor(Color.blue)
                    }
                )
            }
            .overlay(Group {
                if viewStore.isLoading {
                    HUD(isLoading: Binding(
                        get: { viewStore.isLoading },
                        set: { _ in }
                    ))
                }
            }, alignment: .center)
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(title: Text(""), buttons:
                    [
                        .default(Text("編集")) {
                            viewStore.send(.presentEditView)
                        },
                        .destructive(Text("削除")) {
                            viewStore.send(.delete)
                        },
                        .cancel()
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
