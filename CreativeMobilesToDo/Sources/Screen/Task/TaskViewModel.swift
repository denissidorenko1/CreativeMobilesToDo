import Foundation
import SwiftUI

// MARK: - TaskViewModel
final class TaskViewModel: ObservableObject {

    // MARK: - Dependencies
    let persistenceService: ToDoPersistenceService = ToDoPersistenceService.shared

    // MARK: - Public properties
    @Published var title: String
    @Published var description: String
    @Published var creationDate: Date
    @Published var item: ToDoItem?
    @Published var isShowingWarning: Bool = false
    @Published var isClosing: Bool = false
    // MARK: - Private properties

    // MARK: - Initializer
    init(
        title: String = "",
        description: String = "",
        creationDate: Date = .now,
        item: ToDoItem? = nil
    ) {
        if let item {
            self.item = item
            self.title = item.title
            self.description = item.itemDescription
            self.creationDate = item.creationDate
        } else {
            self.title = title
            self.description = description
            self.creationDate = creationDate
            self.item = item
        }
    }

    // MARK: - Public methods
    func saveItem() {
        guard !title.isEmpty && !description.isEmpty else { isShowingWarning = true; return }

        if let item = item {
            let editingItem = ToDoItem(
                id: item.id,
                isDone: item.isDone,
                title: title,
                itemDescription: description,
                creationDate: item.creationDate
            )
            persistenceService.editItem(item: editingItem)
        } else {
            let newItem = ToDoItem(
                isDone: false,
                title: title,
                itemDescription: description,
                creationDate: .now
            )
            persistenceService.addItem(item: newItem)
        }
    }

    // MARK: - Private methods
}
