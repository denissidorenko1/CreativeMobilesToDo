import Foundation
import Combine

// MARK: - ToDoListInteractor
final class ToDoListInteractor: ToDoListInteractorProtocol {

    // MARK: - Dependencies
    private let networkService: ToDoNetworkingService = ToDoNetworkingService.shared
    private let persistenceService: ToDoPersistenceService = ToDoPersistenceService.shared
    private let userDefaultsService: StartTypeService = StartTypeService.shared

    // MARK: - Public properties
    let objectWillChange = PassthroughSubject<Void, Never>()

    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initializer
    init() {
        persistenceService.operationCompletion
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    // MARK: - public methods
    func deleteItem(item: ToDoItem) {
        persistenceService.deleteItem(item: item)
    }

    func toggleStatus(for item: ToDoItem) {
        try? persistenceService.toggleItem(item: item)
    }

    func fetch(completion: @escaping ([ToDoItem]) -> Void) {
        switch userDefaultsService.launchType {
        case .firstTimeLaunch:
            fetchFromNetworkAndSave(completion: completion)
        case .subsequentLaunch:
            fetchFromPersistence(completion: completion)
        }
    }

    // MARK: - Private methods
    private func fetchFromPersistence(completion: @escaping ([ToDoItem]) -> Void) {
        try? persistenceService.fetchItems { [weak self] entityArray in
            DispatchQueue.global(qos: .default).async { [weak self] in
                let items = self?.persistenceService.toList(persistenceItemList: entityArray) ?? []
                completion(items)
            }
        }
    }

    private func fetchFromNetworkAndSave(completion: @escaping ([ToDoItem]) -> Void) {
        Task {
            do {
                let toDoList = try await networkService.getToDoList().toList
                completion(toDoList)
                persistenceService.batchAdd(items: toDoList)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - ToDoListInteractor
protocol ToDoListInteractorProtocol {
    var objectWillChange: PassthroughSubject<Void, Never> { get }

    func deleteItem(item: ToDoItem)
    func toggleStatus(for item: ToDoItem)
    func fetch(completion: @escaping ([ToDoItem]) -> Void)
}
