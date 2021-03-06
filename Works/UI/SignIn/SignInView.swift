import ComposableArchitecture
import SwiftUI

struct SignInView: View {
    let store: Store<SignInVM.State, SignInVM.Action>

    @State private var phoneNumber: String = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    TextFieldInput(value: $phoneNumber, label: "電話番号", keyboardType: .decimalPad)
                    Spacer().frame(height: 40)
                    ActionButton(text: "ログイン", background: .primary) {
                        viewStore.send(.signIn(PhoneNumber(val: phoneNumber)))
                    }
                }
                .padding()
                .navigationBarTitle("ログイン", displayMode: .inline)
                .fullScreenCover(isPresented: Binding(
                    get: { viewStore.shouldShowPinCodeInput },
                    set: { _ in }
                )) {
                    PinCodeInputView { pinCode in
                        viewStore.send(.verify(pinCode))
                    }
                }
            }
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(store: .init(
            initialState: SignInVM.State(),
            reducer: .empty,
            environment: SignInVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
