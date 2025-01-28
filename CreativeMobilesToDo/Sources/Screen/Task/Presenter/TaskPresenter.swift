import SwiftUI

final class TaskPresenter: TaskPresenterProtocol, ObservableObject {

    // MARK: - Dependencies
    private let interactor: TaskInteractorProtocol
    private unowned var router: any TaskRouterProtocol

    // MARK: - Public properties
    @Published var title: String
    @Published var description: String
    @Published var creationDate: Date
    @Published var item: ToDoItem?

    // MARK: - Initializer
    init(
        interactor: TaskInteractor,
        router: TaskRouter,
        item: ToDoItem? = nil,
        title: String = "",
        description: String = "",
        creationDate: Date = .now
    ) {
        self.interactor = interactor
        self.router = router

        if let item {
            self.item = item
            self.title = item.title
            self.description = item.itemDescription
            self.creationDate = item.creationDate
        } else {
            self.title = title
            self.description = description
            self.creationDate = creationDate
            self.item = item
        }
    }

    // MARK: - public methods
    func didTapSave() {
        guard !title.isEmpty && !description.isEmpty else { router.showWarning(); return }

        interactor.saveItem(
            title: title,
            description: description,
            creationDate: creationDate,
            item: item
        )

        router.dismiss()
    }
}

// MARK: - TaskPresenterProtocol
protocol TaskPresenterProtocol: ObservableObject, AnyObject {
    var title: String { get }
    var description: String { get }
    var creationDate: Date { get }
    var item: ToDoItem? { get }

    func didTapSave()
}
