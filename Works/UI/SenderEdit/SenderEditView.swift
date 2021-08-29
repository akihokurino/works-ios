import ComposableArchitecture
import SwiftUI

struct SenderEditView: View {
    let store: Store<SenderEditVM.State, SenderEditVM.Action>

    @State private var isShowActionSheet = false
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var tel: String = ""
    @State private var postalCode: String = ""
    @State private var address: String = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Group {
                        TextFieldInput(value: $name, label: "自社名", keyboardType: .default)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $email, label: "メールアドレス", keyboardType: .emailAddress)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $tel, label: "電話番号", keyboardType: .decimalPad)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $postalCode, label: "郵便番号", keyboardType: .decimalPad)
                        Spacer().frame(height: 20)

                        TextFieldInput(value: $address, label: "住所", keyboardType: .default)
                        Spacer().frame(height: 20)
                    }

                    Spacer().frame(height: 20)
                    ActionButton(text: "登録", background: .primary) {
                        if name.isEmpty || email.isEmpty || tel.isEmpty || postalCode.isEmpty || address.isEmpty {
                            return
                        }

                        viewStore.send(.update(RegisterSenderParams(
                            name: name,
                            email: email,
                            tel: tel,
                            postalCode: postalCode,
                            address: address
                        )))
                    }
                }
                .padding()
                .onAppear {
                    if let sender = viewStore.sender {
                        self.name = sender.name
                        self.email = sender.email
                        self.tel = sender.tel
                        self.postalCode = sender.postalCode
                        self.address = sender.address
                    }
                }
            }
            .navigationBarTitle("自社", displayMode: .inline)
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
            .alert(isPresented: viewStore.binding(
                get: \.isPresentedAlert,
                send: SenderEditVM.Action.isPresentedAlert
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

struct SenderEditView_Previews: PreviewProvider {
    static var previews: some View {
        SenderEditView(store: .init(
            initialState: SenderEditVM.State(),
            reducer: .empty,
            environment: SenderEditVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
