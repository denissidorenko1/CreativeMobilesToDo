import SwiftUI

// MARK: - TaskRouter
final class TaskRouter: TaskRouterProtocol {

    // MARK: - Public properties
    @Published var isShowingWarning: Bool = false
    @Published var isClosing: Bool = false

    // MARK: - Public methods
    func dismiss() {
        isClosing = true
    }

    func showWarning() {
        isShowingWarning = true
    }
}

// MARK: - TaskRouterProtocol
protocol TaskRouterProtocol: ObservableObject, AnyObject {
    var isShowingWarning: Bool { get set }
    var isClosing: Bool { get set }

    func dismiss()
    func showWarning()
}
