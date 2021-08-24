import ComposableArchitecture
import SwiftUI

struct SupplierEditView: View {
    let store: Store<SupplierEditTCA.State, SupplierEditTCA.Action>

    @State private var name: String = ""
    @State private var billingAmount: String = ""
    @State private var subject: String = ""
    @State private var subjectTemplate: String = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Group {
                        TextFieldInput(value: $name, label: "取引先名", keyboardType: .default)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $subject, label: "件名", keyboardType: .default)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $subjectTemplate, label: "件名テンプレート", keyboardType: .default)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $billingAmount, label: "請求額（税抜）", keyboardType: .decimalPad)
                        Spacer().frame(height: 20)
                    }

                    Spacer().frame(height: 20)
                    ActionButton(text: "編集", background: .primary) {
                        let _billingAmount = Int(billingAmount) ?? 0

                        if name.isEmpty || subject.isEmpty || _billingAmount == 0 {
                            return
                        }

                        viewStore.send(.update(UpdateSupplierParams(
                            name: name,
                            billingAmount: _billingAmount,
                            endYm: "",
                            subject: subject,
                            subjectTemplate: subjectTemplate
                        )))
                    }
                }
                .padding()
                .onAppear {
                    self.name = viewStore.state.supplier.name
                    self.billingAmount = String(viewStore.state.supplier.billingAmountExcludeTax)
                    self.subject = viewStore.state.supplier.subject
                    self.subjectTemplate = viewStore.state.supplier.subjectTemplate
                }
            }
            .navigationBarTitle("取引先編集", displayMode: .inline)
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

struct SupplierEditView_Previews: PreviewProvider {
    static var previews: some View {
        SupplierEditView(store: .init(
            initialState: SupplierEditTCA.State(supplier: Supplier.mock),
            reducer: .empty,
            environment: SupplierEditTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
