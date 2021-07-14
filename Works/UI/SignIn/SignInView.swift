//
//  SignInView.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import ComposableArchitecture
import SwiftUI

struct SignInView: View {
    let store: Store<SignInCore.State, SignInCore.Action>

    @State private var phoneNumber: String = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    TextFieldInput(value: $phoneNumber, label: "電話番号", keyboardType: .decimalPad)
                    Spacer().frame(height: 20)
                    ActionButton(text: "ログイン", background: .primary) {
                        viewStore.send(.signIn(PhoneNumber(val: phoneNumber)))
                    }
                }
                .padding()
                .navigationTitle("ログイン")
                .fullScreenCover(isPresented: Binding(
                    get: { viewStore.shouldShowPinCodeInput },
                    set: { _ in return }
                )) {
                    PinCodeInputView()
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(store: .init(
            initialState: SignInCore.State(),
            reducer: SignInCore.reducer,
            environment: SignInCore.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
