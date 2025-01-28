import Foundation

// MARK: - ToDoListRouter
final class ToDoListRouter: ObservableObject {

    // MARK: - Public properties
    @Published var selectedTodoItem: ToDoItem?
    @Published var isToDoViewPresented: Bool = false {
        didSet {
            if !isToDoViewPresented {
                selectedTodoItem = nil
            }
        }
    }

    // MARK: - Public methods
    func navigateToTaskScreen(for item: ToDoItem?) {
        selectedTodoItem = item
        isToDoViewPresented = true
    }

}
