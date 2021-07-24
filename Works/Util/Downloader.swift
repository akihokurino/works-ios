import Combine
import Foundation

struct Downloader {
    static let shared = Downloader()

    let downloadedURL: URL = {
        let fm = FileManager.default
        let url = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url.appendingPathComponent("invoice.pdf")
    }()

    func download(url: URL) -> Future<URL, AppError> {
        return Future<URL, AppError> { promise in
            let task = URLSession.shared.downloadTask(with: url) { url, _, error in
                if let error = error {
                    promise(.failure(.system(error.localizedDescription)))
                    return
                }

                let fm = FileManager.default
                try? fm.removeItem(at: downloadedURL)
                try? fm.moveItem(at: url!, to: downloadedURL)

                promise(.success(downloadedURL))
            }
            task.resume()
        }
    }
}
