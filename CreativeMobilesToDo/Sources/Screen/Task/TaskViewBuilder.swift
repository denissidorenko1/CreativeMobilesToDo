import SwiftUI

// MARK: - TaskViewBuilder
struct TaskViewBuilder {

    // MARK: - static methods
    static func build(with selectedItem: ToDoItem?) -> some View {
        let interactor = TaskInteractor()
        let router = TaskRouter()
        let presenter = TaskPresenter(interactor: interactor, router: router, item: selectedItem)
        return TaskView(presenter: presenter, router: router)
    }
}
