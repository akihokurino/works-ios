//
//  Reducer+CaptureState.swift
//  Works
//
//  Created by akiho on 2021/07/19.
//

import ComposableArchitecture

extension Reducer {
    func captureState(_ capture: @escaping (_ state: State) -> Void) -> Self {
        .init { state, action, environment in
            capture(state)
            return run(&state, action, environment)
        }
    }
}
