import Foundation

// MARK: - ToDoItemListNetworkModel
struct ToDoItemListNetworkModel: Codable {

    // MARK: - Public properties
    let toDos: [ToDoItemNetworkItem]
    let total: Int
    let skip: Int
    let limit: Int

    enum CodingKeys: String, CodingKey {
        case total, skip, limit
        case toDos = "todos"
    }
}
// MARK: - ToDoItemListNetworkModel extension
extension ToDoItemListNetworkModel {
    var toList: [ToDoItem] {
        toDos.map {
            $0.toToDoItem
        }
    }
}
