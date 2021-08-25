import ComposableArchitecture
import SwiftUI

struct SupplierEditView: View {
    let store: Store<SupplierEditTCA.State, SupplierEditTCA.Action>

    @State private var name: String = ""
    @State private var billingAmount: String = ""
    @State private var selectedYearIndex: Int = 0
    @State private var selectedMonthIndex: Int = 0
    @State private var subject: String = ""
    @State private var subjectTemplate: String = ""
    @State private var showYearPicker: Bool = false
    @State private var showMonthPicker: Bool = false

    private var yearSelection: [PickerItem] {
        let currentYear = Calendar.current.component(.year, from: Date())

        return Array(0..<10).map { i in
            let year = currentYear + i
            return PickerItem(label: "\(year)年", value: "\(year)")
        }
    }

    private var monthSelection: [PickerItem] {
        return Array(0..<12).map { i in
            let month = i + 1
            return PickerItem(label: "\(month)月", value: "\(String(format: "%02d", month))")
        }
    }

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

                    if viewStore.supplier.billingType == GraphQL.GraphQLBillingType.oneTime {
                        Group {
                            PickerInput(
                                selectIndex: $selectedYearIndex,
                                showPicker: $showYearPicker,
                                label: "契約終了年（納品時請求のみ）",
                                selection: yearSelection,
                                onTap: {
                                    self.showMonthPicker = false
                                }
                            )
                            Spacer().frame(height: 20)

                            PickerInput(
                                selectIndex: $selectedMonthIndex,
                                showPicker: $showMonthPicker,
                                label: "契約終了月（納品時請求のみ）",
                                selection: monthSelection,
                                onTap: {
                                    self.showYearPicker = false
                                }
                            )
                            Spacer().frame(height: 20)
                        }
                    }

                    Spacer().frame(height: 20)
                    ActionButton(text: "編集", background: .primary) {
                        let _billingAmount = Int(billingAmount) ?? 0

                        if name.isEmpty || subject.isEmpty || _billingAmount == 0 {
                            return
                        }

                        var endYm = ""
                        if viewStore.supplier.billingType == GraphQL.GraphQLBillingType.oneTime {
                            let selectedYear = yearSelection[selectedYearIndex]
                            let selectedMonth = monthSelection[selectedMonthIndex]
                            endYm = "\(selectedYear.value)-\(selectedMonth.value)"
                        }

                        viewStore.send(.update(UpdateSupplierParams(
                            name: name,
                            billingAmount: _billingAmount,
                            endYm: endYm,
                            subject: subject,
                            subjectTemplate: subjectTemplate
                        )))
                    }
                }
                .padding()
                .onAppear {
                    self.name = viewStore.supplier.name
                    self.billingAmount = String(viewStore.supplier.billingAmountExcludeTax)
                    self.subject = viewStore.supplier.subject
                    self.subjectTemplate = viewStore.supplier.subjectTemplate
                    
                    if viewStore.supplier.billingType == GraphQL.GraphQLBillingType.oneTime {
                        guard let endYm = viewStore.supplier.endYm else {
                            return
                        }
                        
                        let year = endYm.split(separator: "-")[0]
                        let month = endYm.split(separator: "-")[1]
                        
                        self.selectedYearIndex = yearSelection.firstIndex(where: { $0.value == year}) ?? 0
                        self.selectedMonthIndex = monthSelection.firstIndex(where: { $0.value == month}) ?? 0
                    }
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
            .overlay(Group {
                PickerView(
                    selectIndex: $selectedYearIndex,
                    showPicker: $showYearPicker,
                    selection: yearSelection
                )
                .animation(.linear)
                .offset(y: showYearPicker ? 0 : UIScreen.main.bounds.height)
            }, alignment: .bottom)
            .overlay(Group {
                PickerView(
                    selectIndex: $selectedMonthIndex,
                    showPicker: $showMonthPicker,
                    selection: monthSelection
                )
                .animation(.linear)
                .offset(y: showMonthPicker ? 0 : UIScreen.main.bounds.height)
            }, alignment: .bottom)
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
