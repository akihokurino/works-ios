// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public enum GraphQL {
  public enum SupplierBillingType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
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

    public static func == (lhs: SupplierBillingType, rhs: SupplierBillingType) -> Bool {
      switch (lhs, rhs) {
        case (.monthly, .monthly): return true
        case (.oneTime, .oneTime): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [SupplierBillingType] {
      return [
        .monthly,
        .oneTime,
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
      mutation CreateSupplier($name: String!, $billingAmount: Int!, $billingType: SupplierBillingType!) {
        createSupplier(
          input: {name: $name, billingAmount: $billingAmount, billingType: $billingType}
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
    public var billingType: SupplierBillingType

    public init(name: String, billingAmount: Int, billingType: SupplierBillingType) {
      self.name = name
      self.billingAmount = billingAmount
      self.billingType = billingType
    }

    public var variables: GraphQLMap? {
      return ["name": name, "billingAmount": billingAmount, "billingType": billingType]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createSupplier", arguments: ["input": ["name": GraphQLVariable("name"), "billingAmount": GraphQLVariable("billingAmount"), "billingType": GraphQLVariable("billingType")]], type: .nonNull(.object(CreateSupplier.selections))),
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

        public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: SupplierBillingType) {
          self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType])
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
      mutation UpdateSupplier($id: String!, $name: String!, $billingAmount: Int!) {
        updateSupplier(input: {id: $id, name: $name, billingAmount: $billingAmount}) {
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

    public init(id: String, name: String, billingAmount: Int) {
      self.id = id
      self.name = name
      self.billingAmount = billingAmount
    }

    public var variables: GraphQLMap? {
      return ["id": id, "name": name, "billingAmount": billingAmount]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("updateSupplier", arguments: ["input": ["id": GraphQLVariable("id"), "name": GraphQLVariable("name"), "billingAmount": GraphQLVariable("billingAmount")]], type: .nonNull(.object(UpdateSupplier.selections))),
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

        public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: SupplierBillingType) {
          self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType])
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

          public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: SupplierBillingType) {
            self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType])
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
        GraphQLField("billingType", type: .nonNull(.scalar(SupplierBillingType.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String, billingAmountIncludeTax: Int, billingAmountExcludeTax: Int, billingType: SupplierBillingType) {
      self.init(unsafeResultMap: ["__typename": "Supplier", "id": id, "name": name, "billingAmountIncludeTax": billingAmountIncludeTax, "billingAmountExcludeTax": billingAmountExcludeTax, "billingType": billingType])
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

    public var billingType: SupplierBillingType {
      get {
        return resultMap["billingType"]! as! SupplierBillingType
      }
      set {
        resultMap.updateValue(newValue, forKey: "billingType")
      }
    }
  }
}
