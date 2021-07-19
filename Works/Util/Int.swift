import Foundation

extension Int {
    var numberString: String {
        guard self < 10 else { return "0" }
        return String(self)
    }
}
