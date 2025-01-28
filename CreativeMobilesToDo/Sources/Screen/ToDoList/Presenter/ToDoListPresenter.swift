import SwiftUI
import Combine

// MARK: - ToDoListPresenter
final class ToDoListPresenter: ObservableObject {

    // MARK: - Dependenices
    private let interactor: ToDoListInteractor

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
    init(interactor: ToDoListInteractor) {
        self.interactor = interactor

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

    // MARK: - Private methods
    private func updateList() {
        interactor.fetch { [weak self] list in
            DispatchQueue.main.async {
                self?.toDoList = list
            }
        }
    }
}
