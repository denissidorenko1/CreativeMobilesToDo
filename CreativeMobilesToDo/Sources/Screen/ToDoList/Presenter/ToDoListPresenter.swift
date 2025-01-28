import SwiftUI
import Combine

// MARK: - ToDoListPresenter
final class ToDoListPresenter: ToDoListPresenterProtocol {

    // MARK: - Dependenices
    private let interactor: ToDoListInteractorProtocol
    private unowned var router: any ToDoListRouterProtocol

    // MARK: - Public properties
    @Published var toDoList: [ToDoItem] = []
    @Published var searchText = ""

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
    init(interactor: ToDoListInteractorProtocol, router: ToDoListRouter) {
        self.interactor = interactor
        self.router = router

        interactor.objectWillChange
            .sink { [weak self] _ in
                self?.updateList()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public methods
    func didTapDelete(item: ToDoItem) {
        interactor.deleteItem(item: item)
    }

    func didToggleStatus(for item: ToDoItem) {
        interactor.toggleStatus(for: item)
    }

    func didAppear() {
        updateList()
    }

    func didTapEdit(item: ToDoItem) {
        router.navigateToTaskScreen(for: item)
    }

    func didTapAddTask() {
        router.navigateToTaskScreen(for: nil)
    }

    // MARK: - Private methods
    private func updateList() {
        interactor.fetch { [weak self] list in
            DispatchQueue.main.async {
                self?.toDoList = list
            }
        }
    }
}

// MARK: - ToDoListPresenterProtocol
protocol ToDoListPresenterProtocol: ObservableObject {
    var toDoList: [ToDoItem] { get }
    var searchText: String { get }
    var itemsShownCount: Int { get }

    func didTapDelete(item: ToDoItem)
    func didToggleStatus(for item: ToDoItem)
    func didAppear()
    func didTapEdit(item: ToDoItem)
    func didTapAddTask()
}
