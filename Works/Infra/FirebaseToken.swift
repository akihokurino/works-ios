//
//  FirebaseToken.swift
//  Works
//
//  Created by akiho on 2021/07/15.
//

import Foundation
import Combine
import Firebase

struct FirebaseToken {
    static func get() -> Future<String, AppError> {
        return Future<String, AppError> { promise in
            guard let me = Auth.auth().currentUser else {
                promise(.success(""))
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
                
                print("-----------------------------------")
                print(token)
                print("-----------------------------------")
                promise(.success(token))
            }
        }
    }
}
