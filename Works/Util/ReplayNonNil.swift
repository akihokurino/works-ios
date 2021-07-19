//
//  ReplayNonNil.swift
//  Works
//
//  Created by akiho on 2021/07/19.
//

import Foundation

func replayNonNil<A, B>(_ inputClosure: @escaping (A) -> B?) -> (A) -> B? {
    var lastNonNilOutput: B?
    return { inputValue in
        guard let outputValue = inputClosure(inputValue) else {
            return lastNonNilOutput
        }
        lastNonNilOutput = outputValue
        return outputValue
    }
}

func replayNonNil<T>() -> (T?) -> T? {
    replayNonNil { $0 }
}
