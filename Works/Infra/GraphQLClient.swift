//
//  GraphQLClient.swift
//  Works
//
//  Created by akiho on 2021/07/17.
//

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
                                Supplier(id: edge.node.id, name: edge.node.name, billingAmount: edge.node.billingAmount, billingType: edge.node.billingType)
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
                                Supplier(id: edge.node.id, name: edge.node.name, billingAmount: edge.node.billingAmount, billingType: edge.node.billingType)
                            }
                        )
                        promise(.success(me))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }
}
