import Foundation

// MARK: - ToDoNetworkingService
final class ToDoNetworkingService {

    // MARK: - Dependencies
    static let shared = ToDoNetworkingService()

    // MARK: - Private properties
    private let networkingService: NetworkingService

    // MARK: - Initializer
    init(networkingService: NetworkingService = DefaultNetworkingService() ) {
        self.networkingService = networkingService
    }

    // MARK: - Public methods
    func getToDoList() async throws -> ToDoItemListNetworkModel {
        try await networkingService.send(request: GetToDoItemListRequest(), type: ToDoItemListNetworkModel.self)
    }
}
