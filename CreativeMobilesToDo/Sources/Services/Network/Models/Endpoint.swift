import Foundation

// MARK: - Endpoint
enum Endpoint {
    // MARK: - cases
    case todo

    // MARK: - Public properties
    static let baseURL: URL = URL(string: "https://dummyjson.com")!

    var path: String {
        switch self {
        case .todo: "todo"
        }
    }

    var url: URL? {
        switch self {
        case .todo:
            URL(string: Endpoint.todo.path, relativeTo: Endpoint.baseURL)
        }
    }
}
