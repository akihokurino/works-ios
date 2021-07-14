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
                    Text("Home")

                } else if viewStore.authState == .shouldLogin {
                    IfLetStore(
                        store.scope(
                            state: { $0.signInState },
                            action: RootCore.Action.signIn
                        ),
                        then: SignInView.init(store:)
                    )
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
