import ComposableArchitecture
import SwiftUI

struct SupplierCreateView: View {
    let store: Store<SupplierCreateVM.State, SupplierCreateVM.Action>

    @State private var name: String = ""
    @State private var billingAmount: String = ""
    @State private var selectedBillingTypeIndex: Int = 0
    @State private var selectedYearIndex: Int = 0
    @State private var selectedMonthIndex: Int = 0
    @State private var subject: String = ""
    @State private var subjectTemplate: String = ""
    @State private var showBillingTypePicker: Bool = false
    @State private var showYearPicker: Bool = false
    @State private var showMonthPicker: Bool = false

    private let billingTypeSelection = [
        PickerItem(label: "月々", value: "0"),
        PickerItem(label: "納品時", value: "1")
    ]

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

                        Group {
                            PickerInput(
                                selectIndex: $selectedBillingTypeIndex,
                                showPicker: $showBillingTypePicker,
                                label: "請求タイミング",
                                selection: billingTypeSelection,
                                onTap: {
                                    self.showYearPicker = false
                                    self.showMonthPicker = false
                                }
                            )
                            Spacer().frame(height: 20)
                            
                            if self.selectedBillingTypeIndex == 1 {
                                PickerInput(
                                    selectIndex: $selectedYearIndex,
                                    showPicker: $showYearPicker,
                                    label: "契約終了年（納品時請求のみ）",
                                    selection: yearSelection,
                                    onTap: {
                                        self.showBillingTypePicker = false
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
                                        self.showBillingTypePicker = false
                                        self.showYearPicker = false
                                    }
                                )
                                Spacer().frame(height: 20)
                            }
                        }
                    }

                    Spacer().frame(height: 20)
                    ActionButton(text: "登録", background: .primary) {
                        var _billingType = GraphQL.GraphQLBillingType.monthly
                        if selectedBillingTypeIndex == 1 {
                            _billingType = GraphQL.GraphQLBillingType.oneTime
                        }

                        let _billingAmount = Int(billingAmount) ?? 0

                        if name.isEmpty || subject.isEmpty || _billingAmount == 0 {
                            return
                        }
                        
                        var endYm = ""
                        if _billingType == GraphQL.GraphQLBillingType.oneTime {
                            let selectedYear = yearSelection[selectedYearIndex]
                            let selectedMonth = monthSelection[selectedMonthIndex]
                            endYm = "\(selectedYear.value)-\(selectedMonth.value)"
                        }

                        viewStore.send(.create(CreateSupplierParams(
                            name: name,
                            billingAmount: _billingAmount,
                            billingType: _billingType,
                            endYm: endYm,
                            subject: subject,
                            subjectTemplate: subjectTemplate
                        )))
                    }
                }
                .padding()
            }
            .navigationBarTitle("取引先登録", displayMode: .inline)
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
            initialState: SupplierCreateVM.State(),
            reducer: .empty,
            environment: SupplierCreateVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
