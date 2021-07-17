//
//  Error.swift
//  Works
//
//  Created by akiho on 2021/07/15.
//

import Foundation

let defaultErrorMsg = "エラーが発生しました"

enum AppError: Error, Equatable {
    case system(String)
}

