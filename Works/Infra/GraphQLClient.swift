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
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let sender: Sender?
                        if let v = data.me.fragments.meFragment.sender {
                            sender = Sender(id: v.fragments.senderFragment.id,
                                            name: v.fragments.senderFragment.name,
                                            email: v.fragments.senderFragment.email,
                                            tel: v.fragments.senderFragment.tel,
                                            postalCode: v.fragments.senderFragment.postalCode,
                                            address: v.fragments.senderFragment.address)
                        } else {
                            sender = nil
                        }

                        let bank: Bank?
                        if let v = data.me.fragments.meFragment.bank {
                            bank = Bank(id: v.fragments.bankFragment.id,
                                        name: v.fragments.bankFragment.name,
                                        code: v.fragments.bankFragment.code,
                                        accountType: v.fragments.bankFragment.accountType,
                                        accountNumber: v.fragments.bankFragment.accountNumber)
                        } else {
                            bank = nil
                        }

                        let me = Me(
                            id: data.me.fragments.meFragment.id,
                            suppliers: data.me.fragments.meFragment.supplierList.edges.map { edge in
                                Supplier(
                                    id: edge.node.fragments.supplierFragment.id,
                                    name: edge.node.fragments.supplierFragment.name,
                                    billingAmountIncludeTax: edge.node.fragments.supplierFragment.billingAmountIncludeTax,
                                    billingAmountExcludeTax: edge.node.fragments.supplierFragment.billingAmountExcludeTax,
                                    billingType: edge.node.fragments.supplierFragment.billingType,
                                    endYm: edge.node.fragments.supplierFragment.endYm,
                                    subject: edge.node.fragments.supplierFragment.subject,
                                    subjectTemplate: edge.node.fragments.supplierFragment.subjectTemplate
                                )
                            },
                            sender: sender,
                            bank: bank
                        )
                        promise(.success(me))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func getInvoiceList(supplierId: String) -> Future<[Invoice], AppError> {
        return Future<[Invoice], AppError> { promise in
            cli.fetch(query: GraphQL.GetInvoiceListQuery(supplierId: supplierId)) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let invoices = data.invoiceList.edges.map { edge in
                            Invoice(
                                id: edge.node.fragments.invoiceFragment.id,
                                issueYMD: edge.node.fragments.invoiceFragment.issueYmd,
                                paymentDueOnYMD: edge.node.fragments.invoiceFragment.paymentDueOnYmd,
                                invoiceNumber: edge.node.fragments.invoiceFragment.invoiceNumber,
                                paymentStatus: edge.node.fragments.invoiceFragment.paymentStatus,
                                invoiceStatus: edge.node.fragments.invoiceFragment.invoiceStatus,
                                recipientName: edge.node.fragments.invoiceFragment.recipientName,
                                subject: edge.node.fragments.invoiceFragment.subject,
                                totalAmount: edge.node.fragments.invoiceFragment.totalAmount,
                                tax: edge.node.fragments.invoiceFragment.tax
                            )
                        }
                        promise(.success(invoices))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func getInvoiceHistoryList() -> Future<[InvoiceHistory], AppError> {
        return Future<[InvoiceHistory], AppError> { promise in
            cli.fetch(query: GraphQL.GetInvoiceHistoryListQuery()) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let histories = data.invoiceHistoryList.edges.map { edge in
                            InvoiceHistory(
                                id: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.id,
                                invoice: Invoice(
                                    id: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.id,
                                    issueYMD: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.issueYmd,
                                    paymentDueOnYMD: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.paymentDueOnYmd,
                                    invoiceNumber: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.invoiceNumber,
                                    paymentStatus: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.paymentStatus,
                                    invoiceStatus: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.invoiceStatus,
                                    recipientName: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.recipientName,
                                    subject: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.subject,
                                    totalAmount: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.totalAmount,
                                    tax: edge.node.fragments.invoiceHistoryFragment.invoice.fragments.invoiceFragment.tax
                                ),
                                supplier: Supplier(
                                    id: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.id,
                                    name: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.name,
                                    billingAmountIncludeTax: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.billingAmountIncludeTax,
                                    billingAmountExcludeTax: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.billingAmountExcludeTax,
                                    billingType: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.billingType,
                                    endYm: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.endYm,
                                    subject: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.subject,
                                    subjectTemplate: edge.node.fragments.invoiceHistoryFragment.supplier.fragments.supplierFragment.subjectTemplate
                                )
                            )
                        }
                        promise(.success(histories))
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
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let sender: Sender?
                        if let v = data.authenticate.fragments.meFragment.sender {
                            sender = Sender(id: v.fragments.senderFragment.id,
                                            name: v.fragments.senderFragment.name,
                                            email: v.fragments.senderFragment.email,
                                            tel: v.fragments.senderFragment.tel,
                                            postalCode: v.fragments.senderFragment.postalCode,
                                            address: v.fragments.senderFragment.address)
                        } else {
                            sender = nil
                        }

                        let bank: Bank?
                        if let v = data.authenticate.fragments.meFragment.bank {
                            bank = Bank(id: v.fragments.bankFragment.id,
                                        name: v.fragments.bankFragment.name,
                                        code: v.fragments.bankFragment.code,
                                        accountType: v.fragments.bankFragment.accountType,
                                        accountNumber: v.fragments.bankFragment.accountNumber)
                        } else {
                            bank = nil
                        }

                        let me = Me(
                            id: data.authenticate.fragments.meFragment.id,
                            suppliers: data.authenticate.fragments.meFragment.supplierList.edges.map { edge in
                                Supplier(
                                    id: edge.node.fragments.supplierFragment.id,
                                    name: edge.node.fragments.supplierFragment.name,
                                    billingAmountIncludeTax: edge.node.fragments.supplierFragment.billingAmountIncludeTax,
                                    billingAmountExcludeTax: edge.node.fragments.supplierFragment.billingAmountExcludeTax,
                                    billingType: edge.node.fragments.supplierFragment.billingType,
                                    endYm: edge.node.fragments.supplierFragment.endYm,
                                    subject: edge.node.fragments.supplierFragment.subject,
                                    subjectTemplate: edge.node.fragments.supplierFragment.subjectTemplate
                                )
                            },
                            sender: sender,
                            bank: bank
                        )
                        promise(.success(me))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func createSupplier(name: String,
                        billingAmount: Int,
                        billingType: GraphQL.GraphQLBillingType,
                        endYm: String,
                        subject: String,
                        subjectTemplate: String) -> Future<Supplier, AppError>
    {
        return Future<Supplier, AppError> { promise in
            cli.perform(mutation: GraphQL.CreateSupplierMutation(
                name: name,
                billingAmount: billingAmount,
                billingType: billingType,
                endYm: endYm,
                subject: subject,
                subjectTemplate: subjectTemplate
            )) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let supplier = Supplier(
                            id: data.createSupplier.fragments.supplierFragment.id,
                            name: data.createSupplier.fragments.supplierFragment.name,
                            billingAmountIncludeTax: data.createSupplier.fragments.supplierFragment.billingAmountIncludeTax,
                            billingAmountExcludeTax: data.createSupplier.fragments.supplierFragment.billingAmountExcludeTax,
                            billingType: data.createSupplier.fragments.supplierFragment.billingType,
                            endYm: data.createSupplier.fragments.supplierFragment.endYm,
                            subject: data.createSupplier.fragments.supplierFragment.subject,
                            subjectTemplate: data.createSupplier.fragments.supplierFragment.subjectTemplate
                        )
                        promise(.success(supplier))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func updateSupplier(id: String,
                        name: String,
                        billingAmount: Int,
                        endYm: String,
                        subject: String,
                        subjectTemplate: String) -> Future<Supplier, AppError>
    {
        return Future<Supplier, AppError> { promise in
            cli.perform(mutation: GraphQL.UpdateSupplierMutation(
                id: id,
                name: name,
                billingAmount: billingAmount,
                endYm: endYm,
                subject: subject,
                subjectTemplate: subjectTemplate
            )) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let supplier = Supplier(
                            id: data.updateSupplier.fragments.supplierFragment.id,
                            name: data.updateSupplier.fragments.supplierFragment.name,
                            billingAmountIncludeTax: data.updateSupplier.fragments.supplierFragment.billingAmountIncludeTax,
                            billingAmountExcludeTax: data.updateSupplier.fragments.supplierFragment.billingAmountExcludeTax,
                            billingType: data.updateSupplier.fragments.supplierFragment.billingType,
                            endYm: data.updateSupplier.fragments.supplierFragment.endYm,
                            subject: data.updateSupplier.fragments.supplierFragment.subject,
                            subjectTemplate: data.updateSupplier.fragments.supplierFragment.subjectTemplate
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
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func downloadInvoicePDF(invoiceId: String) -> Future<URL, AppError> {
        return Future<URL, AppError> { promise in
            cli.perform(mutation: GraphQL.DownloadInvoicePdfMutation(invoiceId: invoiceId)) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        print(data.downloadInvoicePdf)

                        let url = URL(string: data.downloadInvoicePdf)!
                        promise(.success(url))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func deleteInvoice(id: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: GraphQL.DeleteInvoiceMutation(id: id)) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func connectMisoca(code: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: GraphQL.ConnectMisocaMutation(code: code)) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let _ = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func refreshMisoca() -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: GraphQL.RefreshMisocaMutation()) { result in
                switch result {
                    case .success(let graphQLResult):
                        guard let _ = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func registerBank(name: String,
                      code: String,
                      accountType: GraphQL.GraphQLBankAccountType,
                      accountNumber: String) -> Future<Bank, AppError>
    {
        return Future<Bank, AppError> { promise in
            cli.perform(mutation: GraphQL.RegisterBankMutation(
                name: name,
                code: code,
                accountType: accountType,
                accountNumber: accountNumber
            )) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let bank = Bank(id: data.registerBank.fragments.bankFragment.id,
                                        name: data.registerBank.fragments.bankFragment.name,
                                        code: data.registerBank.fragments.bankFragment.code,
                                        accountType: data.registerBank.fragments.bankFragment.accountType,
                                        accountNumber: data.registerBank.fragments.bankFragment.accountNumber)
                        promise(.success(bank))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func registerSender(name: String,
                        email: String,
                        tel: String,
                        postalCode: String,
                        address: String) -> Future<Sender, AppError>
    {
        return Future<Sender, AppError> { promise in
            cli.perform(mutation: GraphQL.RegisterSenderMutation(
                name: name,
                email: email,
                tel: tel,
                postalCode: postalCode,
                address: address
            )) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        guard let data = graphQLResult.data else {
                            promise(.failure(AppError.system(defaultErrorMsg)))
                            return
                        }

                        let sender = Sender(id: data.registerSender.fragments.senderFragment.id,
                                            name: data.registerSender.fragments.senderFragment.name,
                                            email: data.registerSender.fragments.senderFragment.email,
                                            tel: data.registerSender.fragments.senderFragment.tel,
                                            postalCode: data.registerSender.fragments.senderFragment.postalCode,
                                            address: data.registerSender.fragments.senderFragment.address)
                        promise(.success(sender))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }

    func deleteBank(id: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: GraphQL.DeleteBankMutation(id: id)) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }
    
    func deleteSender(id: String) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            cli.perform(mutation: GraphQL.DeleteSenderMutation(id: id)) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let errors = graphQLResult.errors {
                            if !errors.filter({ $0.message != nil }).isEmpty {
                                let messages = errors.filter { $0.message != nil }.map { $0.message! }
                                promise(.failure(AppError.system(messages.joined(separator: "\n"))))
                                return
                            }
                        }

                        promise(.success(()))
                    case .failure(let error):
                        promise(.failure(AppError.system(error.localizedDescription)))
                }
            }
        }
    }
}
