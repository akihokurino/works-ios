//
//  SupplierDetailView.swift
//  Works
//
//  Created by akiho on 2021/07/18.
//

import ComposableArchitecture
import SwiftUI

struct SupplierDetailView: View {
    let store: Store<SupplierDetailTCA.State, SupplierDetailTCA.Action>

    @State private var isShowActionSheet = false

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Text("")
                }
                .padding()
                .navigationBarTitle(viewStore.supplier.name, displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        viewStore.send(.back)
                    }) {
                        Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
                    },
                    trailing: Button(action: {
                        self.isShowActionSheet = true
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .padding(.vertical, 5)
                            .foregroundColor(Color.blue)
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
            .actionSheet(isPresented: $isShowActionSheet) {
                ActionSheet(title: Text(""), buttons:
                    [
                        .default(Text("編集")) {
                            viewStore.send(.presentEditView)
                        },
                        .destructive(Text("削除")) {
                            viewStore.send(.delete)
                        },
                        .cancel()
                    ])
            }
        }
        .navigate(
            using: store.scope(
                state: \.editState,
                action: SupplierDetailTCA.Action.propagateEdit
            ),
            destination: SupplierEditView.init(store:),
            onDismiss: {
                ViewStore(store.stateless).send(.popEditView)
            }
        )
    }
}

//struct SupplierDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SupplierDetailView(store: .init(
//            initialState: SupplierDetailTCA.State(supplier: Supplier.mock),
//            reducer: SupplierDetailTCA.reducer,
//            environment: SupplierDetailTCA.Environment(
//                mainQueue: .main,
//                backgroundQueue: .init(DispatchQueue.global(qos: .background))
//            )
//        ))
//    }
//}
