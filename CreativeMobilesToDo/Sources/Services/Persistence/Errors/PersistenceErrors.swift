import Foundation

// MARK: - PersistenceErrors
enum PersistenceErrors: Error {
    case contextSaveError
    case asyncFetchRequestError
    case fetchRequestError
}
