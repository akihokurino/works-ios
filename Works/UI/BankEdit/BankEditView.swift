import ComposableArchitecture
import SwiftUI

struct BankEditView: View {
    let store: Store<BankEditTCA.State, BankEditTCA.Action>

    @State private var isShowActionSheet = false
    @State private var name: String = ""
    @State private var code: String = ""
    @State private var showAccountTypePicker: Bool = false
    @State private var selectedAccountTypeIndex: Int = 0
    @State private var accountNumber: String = ""

    private let accountTypeSelection = [
        PickerItem(label: "普通", value: "0"),
        PickerItem(label: "当座", value: "1")
    ]

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Group {
                        TextFieldInput(value: $name, label: "銀行支店名", keyboardType: .default)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $code, label: "店番号", keyboardType: .decimalPad)
                        Spacer().frame(height: 20)

                        PickerInput(
                            selectIndex: $selectedAccountTypeIndex,
                            showPicker: $showAccountTypePicker,
                            label: "口座種別",
                            selection: accountTypeSelection,
                            onTap: nil
                        )
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $accountNumber, label: "口座番号", keyboardType: .decimalPad)
                        Spacer().frame(height: 20)
                    }

                    Spacer().frame(height: 20)
                    ActionButton(text: "登録", background: .primary) {
                        if name.isEmpty || code.isEmpty || accountNumber.isEmpty {
                            return
                        }

                        var _accountType = GraphQL.GraphQLBankAccountType.savings
                        if selectedAccountTypeIndex == 1 {
                            _accountType = GraphQL.GraphQLBankAccountType.checking
                        }

                        viewStore.send(.update(RegisterBankParams(
                            name: name,
                            code: code,
                            accountType: _accountType,
                            accountNumber: accountNumber
                        )))
                    }
                }
                .padding()
                .onAppear {
                    if let bank = viewStore.bank {
                        self.name = bank.name
                        self.code = bank.code
                        self.accountNumber = bank.accountNumber
                        
                        switch bank.accountType {
                        case .savings:
                            self.selectedAccountTypeIndex = 0
                        case .checking:
                            self.selectedAccountTypeIndex = 1
                        default:
                            self.selectedAccountTypeIndex = 0
                        }
                    }
                }
            }
            .navigationBarTitle("振込先", displayMode: .inline)
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
                    selectIndex: $selectedAccountTypeIndex,
                    showPicker: $showAccountTypePicker,
                    selection: accountTypeSelection
                )
                .animation(.linear)
                .offset(y: showAccountTypePicker ? 0 : UIScreen.main.bounds.height)
            }, alignment: .bottom)
            .alert(isPresented: viewStore.binding(
                get: \.isPresentedAlert,
                send: BankEditTCA.Action.isPresentedAlert
            )) {
                Alert(title: Text(viewStore.alertText))
            }
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

struct BankEditView_Previews: PreviewProvider {
    static var previews: some View {
        BankEditView(store: .init(
            initialState: BankEditTCA.State(),
            reducer: .empty,
            environment: BankEditTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
