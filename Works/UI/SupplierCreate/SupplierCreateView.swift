import ComposableArchitecture
import SwiftUI

struct SupplierCreateView: View {
    let store: Store<SupplierCreateTCA.State, SupplierCreateTCA.Action>

    @State private var name: String = ""
    @State private var billingAmount: String = ""
    @State private var showBillingTypePicker: Bool = false
    @State private var selectedBillingTypeIndex: Int = 0
    private let billingTypeSelection = [
        PickerItem(label: "月々", value: "0"),
        PickerItem(label: "納品時", value: "1")
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    TextFieldInput(value: $name, label: "取引先名", keyboardType: .default)
                    Spacer().frame(height: 20)

                    TextFieldInput(value: $billingAmount, label: "請求額（税抜）", keyboardType: .decimalPad)
                    Spacer().frame(height: 20)

                    PickerInput(
                        selectIndex: $selectedBillingTypeIndex,
                        showPicker: $showBillingTypePicker,
                        label: "請求タイミング",
                        selection: billingTypeSelection
                    )
                    Spacer().frame(height: 20)

                    Spacer().frame(height: 20)
                    ActionButton(text: "登録", background: .primary) {
                        var _billingType = GraphQL.GraphQLBillingType.monthly
                        if selectedBillingTypeIndex == 1 {
                            _billingType = GraphQL.GraphQLBillingType.oneTime
                        }

                        let _billingAmount = Int(billingAmount) ?? 0

                        if name.isEmpty || _billingAmount == 0 {
                            return
                        }

                        viewStore.send(.create(CreateSupplierParams(
                            name: name,
                            billingAmount: _billingAmount,
                            billingType: _billingType
                        )))
                    }
                }
                .padding()
            }
            .navigationBarTitle("取引先登録", displayMode: .inline)
//            .navigationBarBackButtonHidden(true)
//            .navigationBarItems(
//                leading: Button(action: {
//                    viewStore.send(.back)
//                }) {
//                    Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
//                }
//            )
            .overlay(Group {
                PickerView(
                    selectIndex: $selectedBillingTypeIndex,
                    showPicker: $showBillingTypePicker,
                    selection: billingTypeSelection
                )
                .animation(.linear)
                .offset(y: showBillingTypePicker ? 0 : UIScreen.main.bounds.height)
            }, alignment: .bottom)
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
