import Apollo
import Combine
import Firebase
import Foundation

struct NetworkInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient

    init(store: ApolloStore,
         client: URLSessionClient)
    {
        self.store = store
        self.client = client
    }

    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}

struct GraphQLClient {
    static let shared = GraphQLClient()

    func caller() -> Future<GraphQLCaller, AppError> {
        return Future<GraphQLCaller, AppError> { promise in
            guard let me = Auth.auth().currentUser else {
                promise(.failure(.system(defaultErrorMsg)))
                return
            }

            me.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    promise(.failure(.system(error.localizedDescription)))
                    return
                }

                guard let token = idToken else {
                    promise(.failure(.system(defaultErrorMsg)))
                    return
                }

                print("-----------------------------------")
                print(token)
                print("-----------------------------------")

                let cache = InMemoryNormalizedCache()
                let store = ApolloStore(cache: cache)
                let client = URLSessionClient()
                let provider = NetworkInterceptorProvider(store: store, client: client)

                let transport = RequestChainNetworkTransport(
                    interceptorProvider: provider,
                    endpointURL: URL(string: "https://works-api.akiho.app/graphql")!,
                    additionalHeaders: ["authorization": "bearer \(token)"]
                )

                let apollo = ApolloClient(networkTransport: transport, store: store)

                promise(.success(GraphQLCaller(cli: apollo)))
            }
        }
    }
}

struct GraphQLCaller {
    let cli: ApolloClient

    func me() -> Future<Me, AppError> {
        return Future<Me, AppError> { promise in
            cli.fetch(query: GraphQL.GetMeQuery()) { result in
                switch result {
                    case .success(let graphQLResult):
                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let me = Me(
                            id: data.me.fragments.meFragment.id,
                            suppliers: data.me.fragments.meFragment.suppliers.edges.map { edge in
                                Supplier(
                                    id: edge.node.fragments.supplierFragment.id,
                                    name: edge.node.fragments.supplierFragment.name,
                                    billingAmountIncludeTax: edge.node.fragments.supplierFragment.billingAmountIncludeTax,
                                    billingAmountExcludeTax: edge.node.fragments.supplierFragment.billingAmountExcludeTax,
                                    billingType: edge.node.fragments.supplierFragment.billingType
                                )
                            }
                        )
                        promise(.success(me))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func authenticate() -> Future<Me, AppError> {
        return Future<Me, AppError> { promise in
            cli.perform(mutation: GraphQL.AuthenticateMutation()) { result in
                switch result {
                    case .success(let graphQLResult):
                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let me = Me(
                            id: data.authenticate.fragments.meFragment.id,
                            suppliers: data.authenticate.fragments.meFragment.suppliers.edges.map { edge in
                                Supplier(
                                    id: edge.node.fragments.supplierFragment.id,
                                    name: edge.node.fragments.supplierFragment.name,
                                    billingAmountIncludeTax: edge.node.fragments.supplierFragment.billingAmountIncludeTax,
                                    billingAmountExcludeTax: edge.node.fragments.supplierFragment.billingAmountExcludeTax,
                                    billingType: edge.node.fragments.supplierFragment.billingType
                                )
                            }
                        )
                        promise(.success(me))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func createSupplier(name: String, billingAmount: Int, billingType: GraphQL.SupplierBillingType) -> Future<Supplier, AppError> {
        return Future<Supplier, AppError> { promise in
            cli.perform(mutation: GraphQL.CreateSupplierMutation(name: name, billingAmount: billingAmount, billingType: billingType)) { result in
                switch result {
                    case .success(let graphQLResult):
                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let supplier = Supplier(
                            id: data.createSupplier.fragments.supplierFragment.id,
                            name: data.createSupplier.fragments.supplierFragment.name,
                            billingAmountIncludeTax: data.createSupplier.fragments.supplierFragment.billingAmountIncludeTax,
                            billingAmountExcludeTax: data.createSupplier.fragments.supplierFragment.billingAmountExcludeTax,
                            billingType: data.createSupplier.fragments.supplierFragment.billingType
                        )
                        promise(.success(supplier))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func updateSupplier(id: String, name: String, billingAmount: Int) -> Future<Supplier, AppError> {
        return Future<Supplier, AppError> { promise in
            cli.perform(mutation: GraphQL.UpdateSupplierMutation(id: id, name: name, billingAmount: billingAmount)) { result in
                switch result {
                    case .success(let graphQLResult):
                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let supplier = Supplier(
                            id: data.updateSupplier.fragments.supplierFragment.id,
                            name: data.updateSupplier.fragments.supplierFragment.name,
                            billingAmountIncludeTax: data.updateSupplier.fragments.supplierFragment.billingAmountIncludeTax,
                            billingAmountExcludeTax: data.updateSupplier.fragments.supplierFragment.billingAmountExcludeTax,
                            billingType: data.updateSupplier.fragments.supplierFragment.billingType
                        )
                        promise(.success(supplier))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func deleteSupplier(id: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: GraphQL.DeleteSupplierMutation(id: id)) { result in
                switch result {
                    case .success:
                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }
}
