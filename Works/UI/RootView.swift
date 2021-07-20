import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: Store<RootTCA.State, RootTCA.Action>
    
    var body: some View {
        WithViewStore(store, removeDuplicates: { $0.authState == $1.authState }) { viewStore in
            Group {
                if viewStore.authState == .alreadyLogin {
                    TabView {
                        NavigationView {
                            IfLetStore(
                                store.scope(
                                    state: { $0.supplierListState },
                                    action: RootTCA.Action.propagateSupplierList
                                ),
                                then: SupplierListView.init(store:)
                            )
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "building")
                                Text("取引先")
                            }
                        }.tag(1)

                        NavigationView {
                            IfLetStore(
                                store.scope(
                                    state: { $0.settingState },
                                    action: RootTCA.Action.propagateSetting
                                ),
                                then: SettingView.init(store:)
                            )
                        }
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
                            action: RootTCA.Action.propagateSignIn
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
            initialState: RootTCA.State(),
            reducer: .empty,
            environment: RootTCA.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
 }
