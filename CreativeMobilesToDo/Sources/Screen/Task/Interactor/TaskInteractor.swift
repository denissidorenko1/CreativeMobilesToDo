import Foundation

// MARK: - TaskInteractor
final class TaskInteractor: TaskInteractorProtocol {

    // MARK: - Dependencies
    var persistenceService: ToDoPersistenceServiceProtocol

    init(persistenceService: ToDoPersistenceServiceProtocol = ToDoPersistenceService.shared) {
        self.persistenceService = persistenceService
    }

    // MARK: - Public methods
    func saveItem(title: String, description: String, creationDate: Date, item: ToDoItem?) {
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
}

// MARK: - TaskInteractorProtocol
protocol TaskInteractorProtocol: AnyObject {
    func saveItem(title: String, description: String, creationDate: Date, item: ToDoItem?)
}
