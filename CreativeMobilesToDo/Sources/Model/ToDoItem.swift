import Foundation
import SwiftUI

// MARK: - ToDoModel
struct ToDoItem {

    // MARK: - Public properties
    let id: String
    let isDone: Bool
    let title: String
    let itemDescription: String
    let creationDate: Date

    // MARK: - Initializer
    init(
        id: String = UUID().uuidString,
        isDone: Bool,
        title: String,
        itemDescription: String,
        creationDate: Date
    ) {
        self.id = id
        self.isDone = isDone
        self.title = title
        self.itemDescription = itemDescription
        self.creationDate = creationDate
    }
}

// MARK: - Hashable
extension ToDoItem: Hashable {

}
