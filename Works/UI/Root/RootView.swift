import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: Store<RootVM.State, RootVM.Action>

    var body: some View {
        WithViewStore(store, removeDuplicates: { $0.authState == $1.authState }) { viewStore in
            Group {
                if viewStore.authState == .alreadyLogin {
                    TabView {
                        NavigationView {
                            IfLetStore(
                                store.scope(
                                    state: { $0.supplierListState },
                                    action: RootVM.Action.propagateSupplierList
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
                                    state: { $0.invoiceHistoryListState },
                                    action: RootVM.Action.propagateInvoiceHistoryList
                                ),
                                then: InvoiceHistoryListView.init(store:)
                            )
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "doc")
                                Text("履歴")
                            }
                        }.tag(2)

                        NavigationView {
                            IfLetStore(
                                store.scope(
                                    state: { $0.settingState },
                                    action: RootVM.Action.propagateSetting
                                ),
                                then: SettingView.init(store:)
                            )
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "gearshape")
                                Text("設定")
                            }
                        }.tag(3)
                    }
                } else if viewStore.authState == .shouldLogin {
                    IfLetStore(
                        store.scope(
                            state: { $0.signInState },
                            action: RootVM.Action.propagateSignIn
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
            initialState: RootVM.State(),
            reducer: .empty,
            environment: RootVM.Environment(
                mainQueue: .main,
                backgroundQueue: .init(DispatchQueue.global(qos: .background))
            )
        ))
    }
}
