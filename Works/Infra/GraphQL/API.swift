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
      query GetInvoiceList($supplierId: String!) {
        invoiceList(supplierId: $supplierId) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...InvoiceFragment
            }
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

    public init(supplierId: String) {
      self.supplierId = supplierId
    }

    public var variables: GraphQLMap? {
      return ["supplierId": supplierId]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("invoiceList", arguments: ["supplierId": GraphQLVariable("supplierId")], type: .nonNull(.object(InvoiceList.selections))),
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
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge]) {
          self.init(unsafeResultMap: ["__typename": "InvoiceConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
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
      }
    }
  }

  public final class GetInvoiceHistoryListQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query GetInvoiceHistoryList {
        invoiceHistoryList {
          __typename
          edges {
            __typename
            node {
              __typename
              ...InvoiceHistoryFragment
            }
          }
        }
      }
      """

    public let operationName: String = "GetInvoiceHistoryList"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + InvoiceHistoryFragment.fragmentDefinition)
      return document
    }

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("invoiceHistoryList", type: .nonNull(.object(InvoiceHistoryList.selections))),
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
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge]) {
          self.init(unsafeResultMap: ["__typename": "InvoiceHistoryConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
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
      mutation CreateSupplier($name: String!, $billingAmount: Int!, $billingType: GraphQLBillingType!, $subject: String!) {
        createSupplier(
          input: {name: $name, billingAmount: $billingAmount, billingType: $billingType, subject: $subject}
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
    public var subject: String

    public init(name: String, billingAmount: Int, billingType: GraphQLBillingType, subject: String) {
      self.name = name
      self.billingAmount = billingAmount
      self.billingType = billingType
      self.subject = subject
    }

    public var variables: GraphQLMap? {
      return ["name": name, "billingAmount": billingAmount, "billingType": billingType, "subject": subject]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createSupplier", arguments: ["input": ["name": GraphQLVariable("name"), "billingAmount": GraphQLVariable("billingAmount"), "billingType": GraphQLVariable("billingType"), "subject": GraphQLVariable("subject")]], type: .nonNull(.object(CreateSupplier.selections))),
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

        public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, subject: String) {
          self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "subject": subject])
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
      mutation UpdateSupplier($id: String!, $name: String!, $billingAmount: Int!, $subject: String!) {
        updateSupplier(
          input: {id: $id, name: $name, billingAmount: $billingAmount, subject: $subject}
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
    public var subject: String

    public init(id: String, name: String, billingAmount: Int, subject: String) {
      self.id = id
      self.name = name
      self.billingAmount = billingAmount
      self.subject = subject
    }

    public var variables: GraphQLMap? {
      return ["id": id, "name": name, "billingAmount": billingAmount, "subject": subject]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("updateSupplier", arguments: ["input": ["id": GraphQLVariable("id"), "name": GraphQLVariable("name"), "billingAmount": GraphQLVariable("billingAmount"), "subject": GraphQLVariable("subject")]], type: .nonNull(.object(UpdateSupplier.selections))),
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

        public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, subject: String) {
          self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "subject": subject])
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

  public final class ConnectMisocaMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation connectMisoca($code: String!) {
        connectMisoca(input: {code: $code})
      }
      """

    public let operationName: String = "connectMisoca"

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
      mutation refreshMisoca {
        refreshMisoca
      }
      """

    public let operationName: String = "refreshMisoca"

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
        suppliers {
          __typename
          edges {
            __typename
            node {
              __typename
              ...SupplierFragment
            }
          }
        }
      }
      """

    public static let possibleTypes: [String] = ["Me"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("suppliers", type: .nonNull(.object(Supplier.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, suppliers: Supplier) {
      self.init(unsafeResultMap: ["__typename": "Me", "id": id, "suppliers": suppliers.resultMap])
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

    public var suppliers: Supplier {
      get {
        return Supplier(unsafeResultMap: resultMap["suppliers"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "suppliers")
      }
    }

    public struct Supplier: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SupplierConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge]) {
        self.init(unsafeResultMap: ["__typename": "SupplierConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
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

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SupplierEdge"]

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
          self.init(unsafeResultMap: ["__typename": "SupplierEdge", "node": node.resultMap])
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

          public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, subject: String) {
            self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "subject": subject])
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
        subject
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
        GraphQLField("subject", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, subject: String) {
      self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "subject": subject])
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

    public var subject: String {
      get {
        return resultMap["subject"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "subject")
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
        supplier {
          __typename
          id
          name
          billingAmountIncludeTax
          billingAmountExcludeTax
          billingType
          subject
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

    public struct Supplier: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Supplier"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("billingAmountIncludeTax", type: .nonNull(.scalar(Int.self))),
          GraphQLField("billingAmountExcludeTax", type: .nonNull(.scalar(Int.self))),
          GraphQLField("billingType", type: .nonNull(.scalar(GraphQLBillingType.self))),
          GraphQLField("subject", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: GraphQLBillingType, subject: String) {
        self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType, "subject": subject])
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

      public var subject: String {
        get {
          return resultMap["subject"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "subject")
        }
      }
    }
  }
}
