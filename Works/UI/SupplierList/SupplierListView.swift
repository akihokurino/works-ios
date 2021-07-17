//
//  SupplierListView.swift
//  Works
//
//  Created by akiho on 2021/07/17.
//

import ComposableArchitecture
import SwiftUI

struct SupplierListView: View {
    let store: Store<SupplierListCore.State, SupplierListCore.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    RefreshControl(isRefreshing: Binding(
                        get: { viewStore.isRefreshing },
                        set: { _ in }
                    ), coordinateSpaceName: "RefreshControl", onRefresh: {
                        viewStore.send(.refresh)
                    })

                    VStack {
                        Text("月毎の合計額")
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 20.0))
                        Text("\(viewStore.me.totalAmountInMonthly)円")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .font(Font.system(size: 40.0))
                    }
                    .padding(.top, 40)

                    VStack(spacing: 15) {
                        ForEach(viewStore.me.suppliers, id: \.self) { supplier in
                            SupplierCell(supplier: supplier)
                        }
                    }
                    .padding()
                }
                .coordinateSpace(name: "RefreshControl")
                .navigationBarTitle("取引先", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {}) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.vertical, 5)
                            .foregroundColor(Color.blue)
                    }
                )
            }
        }
    }
}

struct SupplierListView_Previews: PreviewProvider {
    static var previews: some View {
        SupplierListView(store: .init(
            initialState: SupplierListCore.State(me: Me.mock),
            reducer: SupplierListCore.reducer,
            environment: SupplierListCore.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}