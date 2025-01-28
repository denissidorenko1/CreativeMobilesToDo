import SwiftUI

// MARK: - ToDoListViewBuilder
struct ToDoListViewBuilder {

    // MARK: - Public methods
    static func build() -> some View {
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(interactor: interactor, router: router)
        return ToDoListView(presenter: presenter, router: router)
    }
}
