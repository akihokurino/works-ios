import Foundation

let defaultErrorMsg = "エラーが発生しました"

enum AppError: Error, Equatable {
    case system(String)
}

