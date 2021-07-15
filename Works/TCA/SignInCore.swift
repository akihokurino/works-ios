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
                let verificationId = LocalStore.authVerificationId
                state.shouldShowPinCodeInput = !verificationId.isEmpty
                return .none
            case .signIn(let phoneNumber):
                state.isLoading = true
                
                let verify = Future<String, AppError> { promise in
                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber.toE164(), uiDelegate: nil) { verificationId, error in
                        if let error = error {
                            promise(.failure(.system(defaultErrorMsg)))
                            return
                        }
                        
                        guard let verificationId = verificationId else {
                            promise(.failure(.system(defaultErrorMsg)))
                            return
                        }

                        promise(.success(verificationId))
                    }
                }

                return verify.catchToEffect().map(SignInCore.Action.sendVerification)
            case .sendVerification(.success(let verificationId)):
                LocalStore.setAauthVerificationId(val: verificationId)
                state.shouldShowPinCodeInput = true
                state.isLoading = false
                return .none
            case .sendVerification(.failure(_)):
                state.shouldShowPinCodeInput = false
                state.isLoading = false
                return .none
            case .verify(let pinCode):
                let verificationId = LocalStore.authVerificationId
                LocalStore.setAauthVerificationId(val: "")
                state.shouldShowPinCodeInput = false
                state.isLoading = true
                
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationId,
                    verificationCode: pinCode)
                
                let verify = Future<Me, AppError> { promise in
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if let error = error {
                            promise(.failure(.system(defaultErrorMsg)))
                            return
                        }
                        
                        guard let user = authResult?.user else {
                            promise(.failure(.system(defaultErrorMsg)))
                            return
                        }
                        
                        promise(.success(Me(id: user.uid)))
                    }
                }
                
                return verify.catchToEffect().map(SignInCore.Action.verified)
            case .verified(.success(let me)):
                state.isLoading = false
                return .none
            case .verified(.failure(_)):
                state.isLoading = false
                return .none
            }
        }
    )
}

extension SignInCore {
    enum Action: Equatable {
        case onAppear
        case signIn(PhoneNumber)
        case sendVerification(Result<String, AppError>)
        case verify(String)
        case verified(Result<Me, AppError>)
    }

    struct State: Equatable {
        var isLoading: Bool = false
        var shouldShowPinCodeInput: Bool = false
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let backgroundQueue: AnySchedulerOf<DispatchQueue>
    }
}
