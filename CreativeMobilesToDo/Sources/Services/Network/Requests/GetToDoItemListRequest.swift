import Foundation

// MARK: - GetToDoItemListRequest
struct GetToDoItemListRequest: NetworkRequest {
    let endPoint: URL? = Endpoint.todo.url
    let httpMethod: HTTPMethod = .get
}
