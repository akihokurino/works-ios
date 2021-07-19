import Foundation

struct LocalStore {
    static let authVerificationIdKey = "authVerificationID"
    
    static var authVerificationId: String {
        guard let verificationID = UserDefaults.standard.string(forKey: authVerificationIdKey) else {
            return ""
        }
        return verificationID
    }
    
    static func setAauthVerificationId(val: String) {
        UserDefaults.standard.set(val, forKey: authVerificationIdKey)
    }
}
