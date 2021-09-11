import Foundation

struct Paging<T: Equatable>: Equatable {
    let items: [T]
    let hasNext: Bool
    
    func withRefresh(_ isRefresh: Bool) -> PagingWithRefresh<T> {
        return PagingWithRefresh(paging: self, isRefresh: isRefresh)
    }
}

struct PagingWithRefresh<T: Equatable>: Equatable {
    let paging: Paging<T>
    let isRefresh: Bool
}
