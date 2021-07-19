import ComposableArchitecture
import Firebase
import SwiftUI

@main
struct WorksApp: App {
    let store: Store<RootTCA.State, RootTCA.Action> = Store(
        initialState: RootTCA.State(supplierListState: SupplierListTCA.State(me: Me.mock)),
        reducer: RootTCA.reducer,
        environment: RootTCA.Environment(
            mainQueue: .main,
            backgroundQueue: .init(DispatchQueue.global(qos: .background))
        )
    )

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    SupplierListView(store: store.scope(
                        state: \.supplierListState!,
                        action: RootTCA.Action.propagateSupplierList
                    ))
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    VStack {
                        Image(systemName: "building")
                        Text("取引先")
                    }
                }.tag(1)
            }
        }
    }
}
