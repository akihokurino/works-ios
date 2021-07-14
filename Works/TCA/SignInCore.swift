//
//  SignInCore.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import Combine
import ComposableArchitecture
import FirebaseAuth

enum SignInCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .onAppear:
                if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
                    state.shouldShowPinCodeInput = !verificationID.isEmpty
                }
                return .none
            case .signIn(let phoneNumber):
                let verify = Future<String, AppError> { promise in
                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber.toE164(), uiDelegate: nil) { verificationId, error in
                        if let error = error {
                            print(error)
                            promise(.failure(.system(defaultErrorMsg)))
                            return
                        }

                        promise(.success(verificationId!))
                    }
                }

                return verify.catchToEffect().map(SignInCore.Action.verify)
            case .verify(.success(let verificationId)):
                UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
                state.shouldShowPinCodeInput = true
                return .none
            case .verify(.failure(_)):
                state.shouldShowPinCodeInput = false
                return .none
            }
        }
    )
}

extension SignInCore {
    enum Action: Equatable {
        case onAppear
        case signIn(PhoneNumber)
        case verify(Result<String, AppError>)
    }

    struct State: Equatable {
        var shouldShowPinCodeInput: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
