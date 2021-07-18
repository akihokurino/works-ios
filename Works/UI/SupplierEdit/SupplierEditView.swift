//
//  SupplierEditView.swift
//  Works
//
//  Created by akiho on 2021/07/18.
//

import ComposableArchitecture
import SwiftUI

struct SupplierEditView: View {
    let store: Store<SupplierEditCore.State, SupplierEditCore.Action>

    @State private var name: String = ""
    @State private var billingAmount: Int = 0

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    TextFieldInput(value: $name, label: "取引先名", keyboardType: .decimalPad)
                    Spacer().frame(height: 40)

                    ActionButton(text: "編集", background: .primary) {}
                }
                .padding()
                .navigationBarTitle("取引先編集", displayMode: .inline)
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

struct SupplierEditView_Previews: PreviewProvider {
    static var previews: some View {
        SupplierEditView(store: .init(
            initialState: SupplierEditCore.State(),
            reducer: SupplierEditCore.reducer,
            environment: SupplierEditCore.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
