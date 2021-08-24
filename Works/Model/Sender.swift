import Foundation

struct Sender: Equatable, Hashable {
    let id: String
    let name: String
    let email: String
    let tel: String
    let postalCode: String
    let address: String

    static var mock: Sender {
        Sender(id: "", name: "", email: "", tel: "", postalCode: "", address: "")
    }
}
