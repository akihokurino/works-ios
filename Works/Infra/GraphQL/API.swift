// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public enum GraphQL {
  public enum GraphQLBillingType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case monthly
    case oneTime
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "Monthly": self = .monthly
        case "OneTime": self = .oneTime
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .monthly: return "Monthly"
        case .oneTime: return "OneTime"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: GraphQLBillingType, rhs: GraphQLBillingType) -> Bool {
      switch (lhs, rhs) {
        case (.monthly, .monthly): return true
        case (.oneTime, .oneTime): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [GraphQLBillingType] {
      return [
        .monthly,
        .oneTime,
      ]
    }
  }

  public enum GraphQLBankAccountType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case savings
    case checking
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "Savings": self = .savings
        case "Checking": self = .checking
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .savings: return "Savings"
        case .checking: return "Checking"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: GraphQLBankAccountType, rhs: GraphQLBankAccountType) -> Bool {
      switch (lhs, rhs) {
        case (.savings, .savings): return true
        case (.checking, .checking): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [GraphQLBankAccountType] {
      return [
        .savings,
        .checking,
      ]
    }
  }

  public enum GraphQLPaymentStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case unPaid
    case paid
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "UnPaid": self = .unPaid
        case "Paid": self = .paid
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .unPaid: return "UnPaid"
        case .paid: return "Paid"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: GraphQLPaymentStatus, rhs: GraphQLPaymentStatus) -> Bool {
      switch (lhs, rhs) {
        case (.unPaid, .unPaid): return true
        case (.paid, .paid): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [GraphQLPaymentStatus] {
      return [
        .unPaid,
        .paid,
      ]
    }
  }

  public enum GraphQLInvoiceStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case unSubmitted
    case submitted
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "UnSubmitted": self = .unSubmitted
        case "Submitted": self = .submitted
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .unSubmitted: return "UnSubmitted"
        case .submitted: return "Submitted"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: GraphQLInvoiceStatus, rhs: GraphQLInvoiceStatus) -> Bool {
      switch (lhs, rhs) {
        case (.unSubmitted, .unSubmitted): return true
        case (.submitted, .submitted): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [GraphQLInvoiceStatus] {
      return [
        .unSubmitted,
        .submitted,
      ]
    }
  }

  public final class GetMeQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetMe {
        me {
          __typename
          ...MeFragment
        }
      }
      """

    public let operationName: String = "GetMe"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + MeFragment.fragmentDefinition)
      document.append("\n" + SupplierFragment.fragmentDefinition)
      document.append("\n" + SenderFragment.fragmentDefinition)
      document.append("\n" + BankFragment.fragmentDefinition)
      return document
    }

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("me", type: .nonNull(.object(Me.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(me: Me) {
        self.init(unsafeResultMap: ["__typename": "Query", "me": me.resultMap])
      }

      public var me: Me {
        get {
          return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "me")
        }
      }

      public struct Me: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Me"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(MeFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var meFragment: MeFragment {
            get {
              return MeFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public final class GetInvoiceListQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetInvoiceList($supplierId: String!, $page: Int!, $limit: Int!) {
        invoiceList(supplierId: $supplierId, page: $page, limit: $limit) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...InvoiceFragment
            }
          }
          pageInfo {
            __typename
            totalCount
            hasNextPage
          }
        }
      }
      """

    public let operationName: String = "GetInvoiceList"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + InvoiceFragment.fragmentDefinition)
      return document
    }

    public var supplierId: String
    public var page: Int
    public var limit: Int

    public init(supplierId: String, page: Int, limit: Int) {
      self.supplierId = supplierId
      self.page = page
      self.limit = limit
    }

    public var variables: GraphQLMap? {
      return ["supplierId": supplierId, "page": page, "limit": limit]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("invoiceList", arguments: ["supplierId": GraphQLVariable("supplierId"), "page": GraphQLVariable("page"), "limit": GraphQLVariable("limit")], type: .nonNull(.object(InvoiceList.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(invoiceList: InvoiceList) {
        self.init(unsafeResultMap: ["__typename": "Query", "invoiceList": invoiceList.resultMap])
      }

      public var invoiceList: InvoiceList {
        get {
          return InvoiceList(unsafeResultMap: resultMap["invoiceList"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "invoiceList")
        }
      }

      public struct InvoiceList: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["InvoiceConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge], pageInfo: PageInfo) {
          self.init(unsafeResultMap: ["__typename": "InvoiceConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }, "pageInfo": pageInfo.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var edges: [Edge] {
          get {
            return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
          }
        }

        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["InvoiceEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .nonNull(.object(Node.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node) {
            self.init(unsafeResultMap: ["__typename": "InvoiceEdge", "node": node.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var node: Node {
            get {
              return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Invoice"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(InvoiceFragment.self),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, issueYmd: String, paymentDueOnYmd: String, invoiceNumber: String, paymentStatus: GraphQLPaymentStatus, invoiceStatus: GraphQLInvoiceStatus, recipientName: String, subject: String, totalAmount: Int, tax: Int) {
              self.init(unsafeResultMap: ["__typename": "Invoice", "id": id, "issueYmd": issueYmd, "paymentDueOnYmd": paymentDueOnYmd, "invoiceNumber": invoiceNumber, "paymentStatus": paymentStatus, "invoiceStatus": invoiceStatus, "recipientName": recipientName, "subject": subject, "totalAmount": totalAmount, "tax": tax])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var invoiceFragment: InvoiceFragment {
                get {
                  return InvoiceFragment(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(totalCount: Int, hasNextPage: Bool) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "totalCount": totalCount, "hasNextPage": hasNextPage])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var totalCount: Int {
            get {
              return resultMap["totalCount"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "totalCount")
            }
          }

          public var hasNextPage: Bool {
            get {
              return resultMap["hasNextPage"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasNextPage")
            }
          }
        }
      }
    }
  }

  public final class GetInvoiceHistoryListQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetInvoiceHistoryList($page: Int!, $limit: Int!) {
        invoiceHistoryList(page: $page, limit: $limit) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...InvoiceHistoryFragment
            }
          }
          pageInfo {
            __typename
            totalCount
            hasNextPage
          }
        }
      }
      """

    public let operationName: String = "GetInvoiceHistoryList"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + InvoiceHistoryFragment.fragmentDefinition)
      document.append("\n" + InvoiceFragment.fragmentDefinition)
      document.append("\n" + SupplierFragment.fragmentDefinition)
      return document
    }

    public var page: Int
    public var limit: Int

    public init(page: Int, limit: Int) {
      self.page = page
      self.limit = limit
    }

    public var variables: GraphQLMap? {
      return ["page": page, "limit": limit]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("invoiceHistoryList", arguments: ["page": GraphQLVariable("page"), "limit": GraphQLVariable("limit")], type: .nonNull(.object(InvoiceHistoryList.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(invoiceHistoryList: InvoiceHistoryList) {
        self.init(unsafeResultMap: ["__typename": "Query", "invoiceHistoryList": invoiceHistoryList.resultMap])
      }

      public var invoiceHistoryList: InvoiceHistoryList {
        get {
          return InvoiceHistoryList(unsafeResultMap: resultMap["invoiceHistoryList"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "invoiceHistoryList")
        }
      }

      public struct InvoiceHistoryList: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["InvoiceHistoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
            GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge], pageInfo: PageInfo) {
          self.init(unsafeResultMap: ["__typename": "InvoiceHistoryConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }, "pageInfo": pageInfo.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var edges: [Edge] {
          get {
            return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
          }
        }

        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["InvoiceHistoryEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .nonNull(.object(Node.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node) {
            self.init(unsafeResultMap: ["__typename": "InvoiceHistoryEdge", "node": node.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var node: Node {
            get {
              return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["InvoiceHistory"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(InvoiceHistoryFragment.self),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var invoiceHistoryFragment: InvoiceHistoryFragment {
                get {
                  return InvoiceHistoryFragment(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(totalCount: Int, hasNextPage: Bool) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "totalCount": totalCount, "hasNextPage": hasNextPage])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var totalCount: Int {
            get {
              return resultMap["totalCount"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "totalCount")
            }
          }

          public var hasNextPage: Bool {
            get {
              return resultMap["hasNextPage"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasNextPage")
            }
          }
        }
      }
    }
  }

  public final class AuthenticateMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation Authenticate {
        authenticate {
          __typename
          ...MeFragment
        }
      }
      """

    public let operationName: String = "Authenticate"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + MeFragment.fragmentDefinition)
      document.append("\n" + SupplierFragment.fragmentDefinition)
      document.append("\n" + SenderFragment.fragmentDefinition)
      document.append("\n" + BankFragment.fragmentDefinition)
      return document
    }

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("authenticate", type: .nonNull(.object(Authenticate.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(authenticate: Authenticate) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "authenticate": authenticate.resultMap])
      }

      public var authenticate: Authenticate {
        get {
          return Authenticate(unsafeResultMap: resultMap["authenticate"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "authenticate")
        }
      }

      public struct Authenticate: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Me"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(MeFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var meFragment: MeFragment {
            get {
              return MeFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public final class CreateSupplierMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation CreateSupplier($name: String!, $billingAmount: Int!, $billingType: GraphQLBillingType!, $endYm: String!, $subject: String!, $subjectTemplate: String!) {
        createSupplier(
          input: {name: $name, billingAmount: $billingAmount, billingType: $billingType, endYm: $endYm, subject: $subject, subjectTemplate: $subjectTemplate}
        ) {
          __typename
          ...SupplierFragment
        }
      }
      """

    public let operationName: String = "CreateSupplier"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + SupplierFragment.fragmentDefinition)
      return document
    }

    public var name: String
    public var billingAmount: Int
    public var billingType: GraphQLBillingType
    public var endYm: String
    public var subject: String
    public var subjectTemplate: String

    public init(name: String, billingAmount: Int, billingType: GraphQLBillingType, endYm: String, subject: String, subjectTemplate: String) {
      self.name = name
      self.billingAmount = billingAmount
      self.billingType = billingType
      self.endYm = endYm
      self.subject = subject
      self.subjectTemplate = subjectTemplate
    }

    public var variables: GraphQLMap? {
      return ["name": name, "billingAmount": billingAmount, "billingType": billingType, "endYm": endYm, "subject": subject, "subjectTemplate": subjectTemplate]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createSupplier", arguments: ["input": ["name": GraphQLVariable("name"), "billingAmount": GraphQLVariable("billingAmount"), "billingType": GraphQLVariable("billingType"), "endYm": GraphQLVariable("endYm"), "subject": GraphQLVariable("subject"), "subjectTemplate": GraphQLVariable("subjectTemplate")]], type: .nonNull(.object(CreateSupplier.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createSupplier: CreateSupplier) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createSupplier": createSupplier.resultMap])
      }

      public var createSupplier: CreateSupplier {
        get {
          return CreateSupplier(unsafeResultMap: resultMap["createSupplier"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createSupplier")
        }
      }

      public struct CreateSupplier: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Supplier"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(SupplierFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, endYm: String? = nil, subject: String, subjectTemplate: String) {
          self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "endYm": endYm, "subject": subject, "subjectTemplate": subjectTemplate])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var supplierFragment: SupplierFragment {
            get {
              return SupplierFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public final class UpdateSupplierMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation UpdateSupplier($id: String!, $name: String!, $billingAmount: Int!, $endYm: String!, $subject: String!, $subjectTemplate: String!) {
        updateSupplier(
          input: {id: $id, name: $name, billingAmount: $billingAmount, endYm: $endYm, subject: $subject, subjectTemplate: $subjectTemplate}
        ) {
          __typename
          ...SupplierFragment
        }
      }
      """

    public let operationName: String = "UpdateSupplier"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + SupplierFragment.fragmentDefinition)
      return document
    }

    public var id: String
    public var name: String
    public var billingAmount: Int
    public var endYm: String
    public var subject: String
    public var subjectTemplate: String

    public init(id: String, name: String, billingAmount: Int, endYm: String, subject: String, subjectTemplate: String) {
      self.id = id
      self.name = name
      self.billingAmount = billingAmount
      self.endYm = endYm
      self.subject = subject
      self.subjectTemplate = subjectTemplate
    }

    public var variables: GraphQLMap? {
      return ["id": id, "name": name, "billingAmount": billingAmount, "endYm": endYm, "subject": subject, "subjectTemplate": subjectTemplate]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("updateSupplier", arguments: ["input": ["id": GraphQLVariable("id"), "name": GraphQLVariable("name"), "billingAmount": GraphQLVariable("billingAmount"), "endYm": GraphQLVariable("endYm"), "subject": GraphQLVariable("subject"), "subjectTemplate": GraphQLVariable("subjectTemplate")]], type: .nonNull(.object(UpdateSupplier.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateSupplier: UpdateSupplier) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateSupplier": updateSupplier.resultMap])
      }

      public var updateSupplier: UpdateSupplier {
        get {
          return UpdateSupplier(unsafeResultMap: resultMap["updateSupplier"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "updateSupplier")
        }
      }

      public struct UpdateSupplier: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Supplier"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(SupplierFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, endYm: String? = nil, subject: String, subjectTemplate: String) {
          self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "endYm": endYm, "subject": subject, "subjectTemplate": subjectTemplate])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var supplierFragment: SupplierFragment {
            get {
              return SupplierFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public final class RegisterBankMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation RegisterBank($name: String!, $code: String!, $accountType: GraphQLBankAccountType!, $accountNumber: String!) {
        registerBank(
          input: {name: $name, code: $code, accountType: $accountType, accountNumber: $accountNumber}
        ) {
          __typename
          ...BankFragment
        }
      }
      """

    public let operationName: String = "RegisterBank"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + BankFragment.fragmentDefinition)
      return document
    }

    public var name: String
    public var code: String
    public var accountType: GraphQLBankAccountType
    public var accountNumber: String

    public init(name: String, code: String, accountType: GraphQLBankAccountType, accountNumber: String) {
      self.name = name
      self.code = code
      self.accountType = accountType
      self.accountNumber = accountNumber
    }

    public var variables: GraphQLMap? {
      return ["name": name, "code": code, "accountType": accountType, "accountNumber": accountNumber]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("registerBank", arguments: ["input": ["name": GraphQLVariable("name"), "code": GraphQLVariable("code"), "accountType": GraphQLVariable("accountType"), "accountNumber": GraphQLVariable("accountNumber")]], type: .nonNull(.object(RegisterBank.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(registerBank: RegisterBank) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "registerBank": registerBank.resultMap])
      }

      public var registerBank: RegisterBank {
        get {
          return RegisterBank(unsafeResultMap: resultMap["registerBank"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "registerBank")
        }
      }

      public struct RegisterBank: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Bank"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(BankFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, code: String, accountType: GraphQLBankAccountType, accountNumber: String) {
          self.init(unsafeResultMap: ["__typename": "Bank", "id": id, "name": name, "code": code, "accountType": accountType, "accountNumber": accountNumber])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var bankFragment: BankFragment {
            get {
              return BankFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public final class RegisterSenderMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation RegisterSender($name: String!, $email: String!, $tel: String!, $postalCode: String!, $address: String!) {
        registerSender(
          input: {name: $name, email: $email, tel: $tel, postalCode: $postalCode, address: $address}
        ) {
          __typename
          ...SenderFragment
        }
      }
      """

    public let operationName: String = "RegisterSender"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + SenderFragment.fragmentDefinition)
      return document
    }

    public var name: String
    public var email: String
    public var tel: String
    public var postalCode: String
    public var address: String

    public init(name: String, email: String, tel: String, postalCode: String, address: String) {
      self.name = name
      self.email = email
      self.tel = tel
      self.postalCode = postalCode
      self.address = address
    }

    public var variables: GraphQLMap? {
      return ["name": name, "email": email, "tel": tel, "postalCode": postalCode, "address": address]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("registerSender", arguments: ["input": ["name": GraphQLVariable("name"), "email": GraphQLVariable("email"), "tel": GraphQLVariable("tel"), "postalCode": GraphQLVariable("postalCode"), "address": GraphQLVariable("address")]], type: .nonNull(.object(RegisterSender.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(registerSender: RegisterSender) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "registerSender": registerSender.resultMap])
      }

      public var registerSender: RegisterSender {
        get {
          return RegisterSender(unsafeResultMap: resultMap["registerSender"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "registerSender")
        }
      }

      public struct RegisterSender: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Sender"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(SenderFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, email: String, tel: String, postalCode: String, address: String) {
          self.init(unsafeResultMap: ["__typename": "Sender", "id": id, "name": name, "email": email, "tel": tel, "postalCode": postalCode, "address": address])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var senderFragment: SenderFragment {
            get {
              return SenderFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public final class DeleteBankMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation DeleteBank($id: String!) {
        deleteBank(input: {id: $id})
      }
      """

    public let operationName: String = "DeleteBank"

    public var id: String

    public init(id: String) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("deleteBank", arguments: ["input": ["id": GraphQLVariable("id")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(deleteBank: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "deleteBank": deleteBank])
      }

      public var deleteBank: Bool {
        get {
          return resultMap["deleteBank"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "deleteBank")
        }
      }
    }
  }

  public final class DeleteSenderMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation DeleteSender($id: String!) {
        deleteSender(input: {id: $id})
      }
      """

    public let operationName: String = "DeleteSender"

    public var id: String

    public init(id: String) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("deleteSender", arguments: ["input": ["id": GraphQLVariable("id")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(deleteSender: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "deleteSender": deleteSender])
      }

      public var deleteSender: Bool {
        get {
          return resultMap["deleteSender"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "deleteSender")
        }
      }
    }
  }

  public final class DeleteSupplierMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation DeleteSupplier($id: String!) {
        deleteSupplier(input: {id: $id})
      }
      """

    public let operationName: String = "DeleteSupplier"

    public var id: String

    public init(id: String) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("deleteSupplier", arguments: ["input": ["id": GraphQLVariable("id")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(deleteSupplier: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "deleteSupplier": deleteSupplier])
      }

      public var deleteSupplier: Bool {
        get {
          return resultMap["deleteSupplier"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "deleteSupplier")
        }
      }
    }
  }

  public final class DownloadInvoicePdfMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation DownloadInvoicePDF($invoiceId: String!) {
        downloadInvoicePdf(input: {invoiceId: $invoiceId})
      }
      """

    public let operationName: String = "DownloadInvoicePDF"

    public var invoiceId: String

    public init(invoiceId: String) {
      self.invoiceId = invoiceId
    }

    public var variables: GraphQLMap? {
      return ["invoiceId": invoiceId]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("downloadInvoicePdf", arguments: ["input": ["invoiceId": GraphQLVariable("invoiceId")]], type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(downloadInvoicePdf: String) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "downloadInvoicePdf": downloadInvoicePdf])
      }

      public var downloadInvoicePdf: String {
        get {
          return resultMap["downloadInvoicePdf"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "downloadInvoicePdf")
        }
      }
    }
  }

  public final class DeleteInvoiceMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation DeleteInvoice($id: String!) {
        deleteInvoice(input: {id: $id})
      }
      """

    public let operationName: String = "DeleteInvoice"

    public var id: String

    public init(id: String) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("deleteInvoice", arguments: ["input": ["id": GraphQLVariable("id")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(deleteInvoice: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "deleteInvoice": deleteInvoice])
      }

      public var deleteInvoice: Bool {
        get {
          return resultMap["deleteInvoice"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "deleteInvoice")
        }
      }
    }
  }

  public final class ConnectMisocaMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation ConnectMisoca($code: String!) {
        connectMisoca(input: {code: $code})
      }
      """

    public let operationName: String = "ConnectMisoca"

    public var code: String

    public init(code: String) {
      self.code = code
    }

    public var variables: GraphQLMap? {
      return ["code": code]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("connectMisoca", arguments: ["input": ["code": GraphQLVariable("code")]], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(connectMisoca: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "connectMisoca": connectMisoca])
      }

      public var connectMisoca: Bool {
        get {
          return resultMap["connectMisoca"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "connectMisoca")
        }
      }
    }
  }

  public final class RefreshMisocaMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation RefreshMisoca {
        refreshMisoca
      }
      """

    public let operationName: String = "RefreshMisoca"

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("refreshMisoca", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(refreshMisoca: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "refreshMisoca": refreshMisoca])
      }

      public var refreshMisoca: Bool {
        get {
          return resultMap["refreshMisoca"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "refreshMisoca")
        }
      }
    }
  }

  public struct MeFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MeFragment on Me {
        __typename
        id
        supplierList {
          __typename
          ...SupplierFragment
        }
        sender {
          __typename
          ...SenderFragment
        }
        bank {
          __typename
          ...BankFragment
        }
      }
      """

    public static let possibleTypes: [String] = ["Me"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("supplierList", type: .nonNull(.list(.nonNull(.object(SupplierList.selections))))),
        GraphQLField("sender", type: .object(Sender.selections)),
        GraphQLField("bank", type: .object(Bank.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, supplierList: [SupplierList], sender: Sender? = nil, bank: Bank? = nil) {
      self.init(unsafeResultMap: ["__typename": "Me", "id": id, "supplierList": supplierList.map { (value: SupplierList) -> ResultMap in value.resultMap }, "sender": sender.flatMap { (value: Sender) -> ResultMap in value.resultMap }, "bank": bank.flatMap { (value: Bank) -> ResultMap in value.resultMap }])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var supplierList: [SupplierList] {
      get {
        return (resultMap["supplierList"] as! [ResultMap]).map { (value: ResultMap) -> SupplierList in SupplierList(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: SupplierList) -> ResultMap in value.resultMap }, forKey: "supplierList")
      }
    }

    public var sender: Sender? {
      get {
        return (resultMap["sender"] as? ResultMap).flatMap { Sender(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "sender")
      }
    }

    public var bank: Bank? {
      get {
        return (resultMap["bank"] as? ResultMap).flatMap { Bank(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "bank")
      }
    }

    public struct SupplierList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Supplier"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(SupplierFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, endYm: String? = nil, subject: String, subjectTemplate: String) {
        self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "endYm": endYm, "subject": subject, "subjectTemplate": subjectTemplate])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var supplierFragment: SupplierFragment {
          get {
            return SupplierFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct Sender: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Sender"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(SenderFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, email: String, tel: String, postalCode: String, address: String) {
        self.init(unsafeResultMap: ["__typename": "Sender", "id": id, "name": name, "email": email, "tel": tel, "postalCode": postalCode, "address": address])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var senderFragment: SenderFragment {
          get {
            return SenderFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct Bank: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Bank"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(BankFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, code: String, accountType: GraphQLBankAccountType, accountNumber: String) {
        self.init(unsafeResultMap: ["__typename": "Bank", "id": id, "name": name, "code": code, "accountType": accountType, "accountNumber": accountNumber])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var bankFragment: BankFragment {
          get {
            return BankFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }

  public struct SupplierFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment SupplierFragment on Supplier {
        __typename
        id
        name
        billingAmountIncludeTax
        billingAmountExcludeTax
        billingType
        endYm
        subject
        subjectTemplate
      }
      """

    public static let possibleTypes: [String] = ["Supplier"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("billingAmountIncludeTax", type: .nonNull(.scalar(Int.self))),
        GraphQLField("billingAmountExcludeTax", type: .nonNull(.scalar(Int.self))),
        GraphQLField("billingType", type: .nonNull(.scalar(GraphQLBillingType.self))),
        GraphQLField("endYm", type: .scalar(String.self)),
        GraphQLField("subject", type: .nonNull(.scalar(String.self))),
        GraphQLField("subjectTemplate", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, endYm: String? = nil, subject: String, subjectTemplate: String) {
      self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "endYm": endYm, "subject": subject, "subjectTemplate": subjectTemplate])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var billingAmountIncludeTax: Int {
      get {
        return resultMap["billingAmountIncludeTax"]! as! Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "billingAmountIncludeTax")
      }
    }

    public var billingAmountExcludeTax: Int {
      get {
        return resultMap["billingAmountExcludeTax"]! as! Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "billingAmountExcludeTax")
      }
    }

    public var billingType: GraphQLBillingType {
      get {
        return resultMap["billingType"]! as! GraphQLBillingType
      }
      set {
        resultMap.updateValue(newValue, forKey: "billingType")
      }
    }

    public var endYm: String? {
      get {
        return resultMap["endYm"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "endYm")
      }
    }

    public var subject: String {
      get {
        return resultMap["subject"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "subject")
      }
    }

    public var subjectTemplate: String {
      get {
        return resultMap["subjectTemplate"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "subjectTemplate")
      }
    }
  }

  public struct InvoiceFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment InvoiceFragment on Invoice {
        __typename
        id
        issueYmd
        paymentDueOnYmd
        invoiceNumber
        paymentStatus
        invoiceStatus
        recipientName
        subject
        totalAmount
        tax
      }
      """

    public static let possibleTypes: [String] = ["Invoice"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("issueYmd", type: .nonNull(.scalar(String.self))),
        GraphQLField("paymentDueOnYmd", type: .nonNull(.scalar(String.self))),
        GraphQLField("invoiceNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("paymentStatus", type: .nonNull(.scalar(GraphQLPaymentStatus.self))),
        GraphQLField("invoiceStatus", type: .nonNull(.scalar(GraphQLInvoiceStatus.self))),
        GraphQLField("recipientName", type: .nonNull(.scalar(String.self))),
        GraphQLField("subject", type: .nonNull(.scalar(String.self))),
        GraphQLField("totalAmount", type: .nonNull(.scalar(Int.self))),
        GraphQLField("tax", type: .nonNull(.scalar(Int.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, issueYmd: String, paymentDueOnYmd: String, invoiceNumber: String, paymentStatus: GraphQLPaymentStatus, invoiceStatus: GraphQLInvoiceStatus, recipientName: String, subject: String, totalAmount: Int, tax: Int) {
      self.init(unsafeResultMap: ["__typename": "Invoice", "id": id, "issueYmd": issueYmd, "paymentDueOnYmd": paymentDueOnYmd, "invoiceNumber": invoiceNumber, "paymentStatus": paymentStatus, "invoiceStatus": invoiceStatus, "recipientName": recipientName, "subject": subject, "totalAmount": totalAmount, "tax": tax])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var issueYmd: String {
      get {
        return resultMap["issueYmd"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "issueYmd")
      }
    }

    public var paymentDueOnYmd: String {
      get {
        return resultMap["paymentDueOnYmd"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "paymentDueOnYmd")
      }
    }

    public var invoiceNumber: String {
      get {
        return resultMap["invoiceNumber"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "invoiceNumber")
      }
    }

    public var paymentStatus: GraphQLPaymentStatus {
      get {
        return resultMap["paymentStatus"]! as! GraphQLPaymentStatus
      }
      set {
        resultMap.updateValue(newValue, forKey: "paymentStatus")
      }
    }

    public var invoiceStatus: GraphQLInvoiceStatus {
      get {
        return resultMap["invoiceStatus"]! as! GraphQLInvoiceStatus
      }
      set {
        resultMap.updateValue(newValue, forKey: "invoiceStatus")
      }
    }

    public var recipientName: String {
      get {
        return resultMap["recipientName"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "recipientName")
      }
    }

    public var subject: String {
      get {
        return resultMap["subject"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "subject")
      }
    }

    public var totalAmount: Int {
      get {
        return resultMap["totalAmount"]! as! Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "totalAmount")
      }
    }

    public var tax: Int {
      get {
        return resultMap["tax"]! as! Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "tax")
      }
    }
  }

  public struct InvoiceHistoryFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment InvoiceHistoryFragment on InvoiceHistory {
        __typename
        invoice {
          __typename
          ...InvoiceFragment
        }
        supplier {
          __typename
          ...SupplierFragment
        }
      }
      """

    public static let possibleTypes: [String] = ["InvoiceHistory"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("invoice", type: .nonNull(.object(Invoice.selections))),
        GraphQLField("supplier", type: .nonNull(.object(Supplier.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(invoice: Invoice, supplier: Supplier) {
      self.init(unsafeResultMap: ["__typename": "InvoiceHistory", "invoice": invoice.resultMap, "supplier": supplier.resultMap])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var invoice: Invoice {
      get {
        return Invoice(unsafeResultMap: resultMap["invoice"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "invoice")
      }
    }

    public var supplier: Supplier {
      get {
        return Supplier(unsafeResultMap: resultMap["supplier"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "supplier")
      }
    }

    public struct Invoice: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Invoice"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(InvoiceFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, issueYmd: String, paymentDueOnYmd: String, invoiceNumber: String, paymentStatus: GraphQLPaymentStatus, invoiceStatus: GraphQLInvoiceStatus, recipientName: String, subject: String, totalAmount: Int, tax: Int) {
        self.init(unsafeResultMap: ["__typename": "Invoice", "id": id, "issueYmd": issueYmd, "paymentDueOnYmd": paymentDueOnYmd, "invoiceNumber": invoiceNumber, "paymentStatus": paymentStatus, "invoiceStatus": invoiceStatus, "recipientName": recipientName, "subject": subject, "totalAmount": totalAmount, "tax": tax])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var invoiceFragment: InvoiceFragment {
          get {
            return InvoiceFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }

    public struct Supplier: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Supplier"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(SupplierFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, endYm: String? = nil, subject: String, subjectTemplate: String) {
        self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "endYm": endYm, "subject": subject, "subjectTemplate": subjectTemplate])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var supplierFragment: SupplierFragment {
          get {
            return SupplierFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }

  public struct BankFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment BankFragment on Bank {
        __typename
        id
        name
        code
        accountType
        accountNumber
      }
      """

    public static let possibleTypes: [String] = ["Bank"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("code", type: .nonNull(.scalar(String.self))),
        GraphQLField("accountType", type: .nonNull(.scalar(GraphQLBankAccountType.self))),
        GraphQLField("accountNumber", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String, code: String, accountType: GraphQLBankAccountType, accountNumber: String) {
      self.init(unsafeResultMap: ["__typename": "Bank", "id": id, "name": name, "code": code, "accountType": accountType, "accountNumber": accountNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var code: String {
      get {
        return resultMap["code"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "code")
      }
    }

    public var accountType: GraphQLBankAccountType {
      get {
        return resultMap["accountType"]! as! GraphQLBankAccountType
      }
      set {
        resultMap.updateValue(newValue, forKey: "accountType")
      }
    }

    public var accountNumber: String {
      get {
        return resultMap["accountNumber"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "accountNumber")
      }
    }
  }

  public struct SenderFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment SenderFragment on Sender {
        __typename
        id
        name
        email
        tel
        postalCode
        address
      }
      """

    public static let possibleTypes: [String] = ["Sender"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("email", type: .nonNull(.scalar(String.self))),
        GraphQLField("tel", type: .nonNull(.scalar(String.self))),
        GraphQLField("postalCode", type: .nonNull(.scalar(String.self))),
        GraphQLField("address", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String, email: String, tel: String, postalCode: String, address: String) {
      self.init(unsafeResultMap: ["__typename": "Sender", "id": id, "name": name, "email": email, "tel": tel, "postalCode": postalCode, "address": address])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var email: String {
      get {
        return resultMap["email"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "email")
      }
    }

    public var tel: String {
      get {
        return resultMap["tel"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "tel")
      }
    }

    public var postalCode: String {
      get {
        return resultMap["postalCode"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "postalCode")
      }
    }

    public var address: String {
      get {
        return resultMap["address"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "address")
      }
    }
  }
}
