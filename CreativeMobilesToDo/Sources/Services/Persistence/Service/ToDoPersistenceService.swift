import Foundation
import CoreData
import Combine

// MARK: - ToDoDataController
final class ToDoPersistenceService: ToDoPersistenceServiceProtocol {

    // MARK: - Public properties
    static let shared = ToDoPersistenceService()
    let operationCompletion = PassthroughSubject<Void, Never>()

    // MARK: - Private properties
    private let container = NSPersistentContainer(name: "ToDoDataModel")
    private lazy var backgroundContext = container.newBackgroundContext()

    // MARK: - Initializer
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("Ошибка загрузки \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Public methods
    func addItem(item: ToDoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            let toDoEntity = ToDoEntity(context: self.backgroundContext)
            toDoEntity.id = item.id
            toDoEntity.title = item.title
            toDoEntity.itemDescription = item.itemDescription
            toDoEntity.isDone = item.isDone
            toDoEntity.creationDate = item.creationDate
            saveContext()
        }
    }

    func batchAdd(items: [ToDoItem]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            for item in items {
                let toDoEntity = ToDoEntity(context: self.backgroundContext)
                toDoEntity.id = item.id
                toDoEntity.title = item.title
                toDoEntity.itemDescription = item.itemDescription
                toDoEntity.isDone = item.isDone
                toDoEntity.creationDate = item.creationDate
            }
            saveContext()
        }
    }

    func deleteItem(item: ToDoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id)

            if let result = try? backgroundContext.fetch(fetchRequest).first {
                backgroundContext.delete(result)
                saveContext()
            }

        }
    }

    func editItem(item: ToDoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id)

            if let result = try? backgroundContext.fetch(fetchRequest).first {
                result.title = item.title
                result.itemDescription = item.itemDescription
                result.isDone = item.isDone
                result.creationDate = result.creationDate
                saveContext()
            }
        }
    }

    func toggleItem(item: ToDoItem) throws {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id)

            if let result = try? backgroundContext.fetch(fetchRequest).first {
                result.isDone.toggle()
                saveContext()
            }
        }
    }

    func fetchItems(completion: @escaping ([ToDoEntity]) -> Void) throws {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()

        let asyncFetchRequest = NSAsynchronousFetchRequest<ToDoEntity>(fetchRequest: request) { result in
            completion(result.finalResult ?? [])
        }

        do {
            try self.backgroundContext.execute(asyncFetchRequest)
        } catch {
            throw PersistenceErrors.fetchRequestError
        }
    }

    func deleteAllItems() {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()

        do {
            let entities = try backgroundContext.fetch(fetchRequest)

            for entity in entities {
                backgroundContext.delete(entity)
            }

            try backgroundContext.save()
            operationCompletion.send()
        } catch {
            print("Ошибка удаления \(error)")
        }
    }

    // MARK: - Private methods
    private func saveContext() {
        do {
            try backgroundContext.save()
            operationCompletion.send()
        } catch {
            print("Ошибка сохранения контекста: \(error)")
        }
    }
}

// MARK: - Extension
extension ToDoPersistenceService {
    func toList(persistenceItemList: [ToDoEntity]) -> [ToDoItem] {
        persistenceItemList.compactMap { entity in
            ToDoItem(
                id: entity.id ?? "",
                isDone: entity.isDone,
                title: entity.title ?? "",
                itemDescription: entity.itemDescription ?? "",
                creationDate: entity.creationDate ?? Date()
            )
        }
    }
}

// MARK: - ToDoPersistenceServiceProtol
protocol ToDoPersistenceServiceProtocol {
    func addItem(item: ToDoItem)
    func batchAdd(items: [ToDoItem])
    func deleteItem(item: ToDoItem)
    func editItem(item: ToDoItem)
    func toggleItem(item: ToDoItem) throws
    func fetchItems(completion: @escaping ([ToDoEntity]) -> Void) throws
    func deleteAllItems()
}
