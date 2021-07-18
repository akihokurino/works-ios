//
//  SupplierDetailView.swift
//  Works
//
//  Created by akiho on 2021/07/18.
//

import ComposableArchitecture
import SwiftUI

struct SupplierDetailView: View {
    let store: Store<SupplierDetailCore.State, SupplierDetailCore.Action>

    @State private var isShowActionSheet = false
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                Group {
                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(
                                state: { $0.editState },
                                action: SupplierDetailCore.Action.propagateEdit
                            )
                        ) {
                            SupplierEditView(store: $0)
                        },
                        isActive: Binding(
                            get: { viewStore.editState != nil },
                            set: { _ in }
                        )
                    ) {
                        EmptyView()
                    }
                }

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
    }
}

struct SupplierDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SupplierDetailView(store: .init(
            initialState: SupplierDetailCore.State(supplier: Supplier.mock),
            reducer: SupplierDetailCore.reducer,
            environment: SupplierDetailCore.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
