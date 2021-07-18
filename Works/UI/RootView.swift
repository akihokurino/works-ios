//
//  RootView.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: Store<RootCore.State, RootCore.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                if viewStore.authState == .alreadyLogin {
                    TabView {
                        IfLetStore(
                            store.scope(
                                state: { $0.supplierListState },
                                action: RootCore.Action.propagateSupplierList
                            ),
                            then: SupplierListView.init(store:)
                        )
                        .tabItem {
                            VStack {
                                Image(systemName: "building")
                                Text("取引先")
                            }
                        }.tag(1)
                        IfLetStore(
                            store.scope(
                                state: { $0.settingState },
                                action: RootCore.Action.propagateSetting
                            ),
                            then: SettingView.init(store:)
                        )
                        .tabItem {
                            VStack {
                                Image(systemName: "gearshape")
                                Text("設定")
                            }
                        }.tag(2)
                    }
                } else if viewStore.authState == .shouldLogin {
                    IfLetStore(
                        store.scope(
                            state: { $0.signInState },
                            action: RootCore.Action.propagateSignIn
                        ),
                        then: SignInView.init(store:)
                    )
                } else {
                    HUD(isLoading: .constant(true))
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: .init(
            initialState: RootCore.State(),
            reducer: RootCore.reducer,
            environment: RootCore.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
