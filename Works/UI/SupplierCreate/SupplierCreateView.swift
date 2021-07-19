import ComposableArchitecture
import SwiftUI

struct SupplierCreateView: View {
    let store: Store<SupplierCreateTCA.State, SupplierCreateTCA.Action>

    @State private var name: String = ""
    @State private var billingAmount: String = ""
    @State private var billingType = GraphQL.SupplierBillingType.monthly

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    TextFieldInput(value: $name, label: "取引先名", keyboardType: .default)
                    Spacer().frame(height: 20)

                    TextFieldInput(value: $billingAmount, label: "請求額", keyboardType: .decimalPad)
                    Spacer().frame(height: 40)

                    ActionButton(text: "登録", background: .primary) {}
                }
                .padding()
                .navigationBarTitle("取引先登録", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        viewStore.send(.back)
                    }) {
                        Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
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
        }
    }
}

 struct SupplierCreateView_Previews: PreviewProvider {
    static var previews: some View {
        SupplierCreateView(store: .init(
            initialState: SupplierCreateTCA.State(),
            reducer: .empty,
            environment: SupplierCreateTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
 }
