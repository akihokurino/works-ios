import Foundation

struct PhoneNumber: Equatable {
    let val: String

    func toE164() -> String {
        assert(val.count == 11)
        return "+81" + String(val.dropFirst())
    }
}
