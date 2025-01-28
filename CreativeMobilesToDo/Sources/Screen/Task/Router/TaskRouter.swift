import SwiftUI

// MARK: - TaskRouter
final class TaskRouter: ObservableObject {

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
