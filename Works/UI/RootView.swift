//
//  RootView.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: Store<RootTCA.State, RootTCA.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                IfLetStore(
                    store.scope(
                        state: { $0.supplierListState },
                        action: RootTCA.Action.propagateSupplierList
                    ),
                    then: SupplierListView.init(store:)
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView(store: .init(
//            initialState: RootTCA.State(),
//            reducer: RootTCA.reducer,
//            environment: RootTCA.Environment(
//                mainQueue: .main,
//                backgroundQueue: .init(DispatchQueue.global(qos: .background))
//            )
//        ))
//    }
//}
