import Foundation

// MARK: - ToDoListRouter
final class ToDoListRouter: ToDoListRouterProtocol {

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

// MARK: - ToDoListRouterProtocol
protocol ToDoListRouterProtocol: ObservableObject {
    var selectedTodoItem: ToDoItem? { get set }
    var isToDoViewPresented: Bool { get set }

    func navigateToTaskScreen(for item: ToDoItem?)
}
