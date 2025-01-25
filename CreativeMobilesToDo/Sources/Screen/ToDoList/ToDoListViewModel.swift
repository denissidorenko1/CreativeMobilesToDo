import SwiftUI
import Combine

// MARK: - ToDoListViewModel
final class ToDoListViewModel: ObservableObject {

    // MARK: - Dependencies
    private let networkService: ToDoNetworkingService = ToDoNetworkingService.shared
    private let persistenceService: ToDoPersistenceService = ToDoPersistenceService.shared
    private let userDefaultsService: StartTypeService = StartTypeService.shared

    // MARK: - Public properties
    @Published var toDoList: [ToDoItem] = []
    @Published var selectedTodoItem: ToDoItem?
    @Published var searchText = ""
    @Published var isToDoViewPresented: Bool = false {
        didSet {
            if !isToDoViewPresented {
                selectedTodoItem = nil
            }
        }
    }

    var filteredItems: [ToDoItem] {
        guard !searchText.isEmpty else {
            itemsShownCount = toDoList.count
            return toDoList.sorted { $0.creationDate > $1.creationDate}
        }
        let filtered = toDoList.filter {$0.title.localizedCaseInsensitiveContains(searchText)}
        itemsShownCount = filtered.count
        return filtered.sorted { $0.creationDate > $1.creationDate}
    }

    var itemsShownCount = 0

    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init() {
        persistenceService.operationCompletion
            .sink { [weak self] _ in
                self?.fetchFromPersistence()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public methods
    func addNewItem(item: ToDoItem) {
        persistenceService.addItem(item: item)
    }

    func deleteItem(item: ToDoItem) {
        persistenceService.deleteItem(item: item)
    }

    func editItem(item: ToDoItem) {
        persistenceService.editItem(item: item)
    }

    func toggleStatus(for item: ToDoItem) {
        try? persistenceService.toggleItem(item: item)
    }

    func fetch() {
        switch userDefaultsService.launchType {
        case .firstTimeLaunch:
            fetchFromNetworkAndSave()
        case .subsequentLaunch:
            fetchFromPersistence()
        }
    }

    // MARK: - Private methods
    private func fetchFromPersistence() {
        try? persistenceService.fetchItems { [weak self] entityArray in
            DispatchQueue.global(qos: .default).async { [weak self] in
                let items = self?.persistenceService.toList(persistenceItemList: entityArray)
                DispatchQueue.main.async { [weak self] in
                    self?.toDoList = items ?? []
                }
            }
        }
    }

    private func fetchFromNetworkAndSave() {
        Task {
            do {
                toDoList = try await networkService.getToDoList().toList
                persistenceService.batchAdd(items: toDoList)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

protocol ListToDoViewModelProtocol: ObservableObject {
    var searchText: String { get set }
    var isSearching: Bool { get set }
    var isTapped: Bool { get set }
    var isShowing: Bool { get set }
//    var toDoList: ToDoListModel { get }
    func fetchToDoListFromNetwork()
    func toggleStatus(for model: ToDoItem)
}
