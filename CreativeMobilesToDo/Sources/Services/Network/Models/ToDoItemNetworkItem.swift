import Foundation

// MARK: - ToDoItemNetworkModel
struct ToDoItemNetworkItem: Codable {

    // MARK: - Public properties
    let id: Int
    let toDo: String
    let isCompleted: Bool
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case id, userId
        case toDo = "todo"
        case isCompleted = "completed"
    }
}

// MARK: - ToDoItemNetworkModel extension
extension ToDoItemNetworkItem {
    var toToDoItem: ToDoItem {
        ToDoItem(
            id: "\(id)",
            isDone: isCompleted,
            title: toDo,
            itemDescription: "",
            creationDate: .now
        )
    }
}
