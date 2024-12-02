import XCTest
import Combine
import CoreData
@testable import CreativeMobilesToDo


final class ToDoItemPersistenceTests: XCTestCase {
    private var service = ToDoPersistenceService.shared
    
    override func setUpWithError() throws {
        var cancellable: Set<AnyCancellable> = []
        let deletionExpectation = XCTestExpectation()
        
        let _ = service.operationCompletion
            .sink { _ in
                deletionExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.deleteAllItems()
        wait(for: [deletionExpectation], timeout: 5)
    }

    override func tearDownWithError() throws {
        
    }
    
    func testBatchAdd() {
        var cancellable: Set<AnyCancellable> = []
        let items: [ToDoItem] = [
            ToDoItem(isDone: true, title: "title1", itemDescription: "description1", creationDate: .now),
            ToDoItem(isDone: false, title: "title2", itemDescription: "description2", creationDate: .now),
            ToDoItem(isDone: true, title: "title3", itemDescription: "description3", creationDate: .now),
            ToDoItem(isDone: false, title: "title4", itemDescription: "description4", creationDate: .now),
        ]

        let batchAdditionExpectation = XCTestExpectation()
        
        let _ = service.operationCompletion
            .sink { _ in
                batchAdditionExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.batchAdd(items: items)
        wait(for: [batchAdditionExpectation])
        
        let fetchExpectation = XCTestExpectation()
        try? service.fetchItems(completion: { [weak self] fetchedItems in
            let mappedItems = self?.service.toList(persistenceItemList: fetchedItems)
            XCTAssert(mappedItems!.sorted {$0.id < $1.id} == items.sorted { $0.id < $1.id})
            fetchExpectation.fulfill()
        })
        wait(for: [fetchExpectation], timeout: 5)
    }
    

    func testUpdateItem() {
        var cancellable: Set<AnyCancellable> = []
        var item: ToDoItem = ToDoItem(
            id: "qwerty",
            isDone: false,
            title: "title",
            itemDescription: "description",
            creationDate: .now
        )
        
        let additionExpectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                additionExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.addItem(item: item)
        wait(for: [additionExpectation], timeout: 1)
        
        let editExpectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                editExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        let editedItem: ToDoItem = ToDoItem(
            id: item.id,
            isDone: !item.isDone,
            title: "another title",
            itemDescription: "another description",
            creationDate: Date(timeIntervalSince1970: 1)
        )
        
        service.editItem(item: editedItem)
        wait(for: [editExpectation], timeout: 5)
        
        
        let fetchExpectation = XCTestExpectation()
        try? service.fetchItems(completion: { fetchedItems in
            XCTAssertTrue(fetchedItems.count == 1)
            XCTAssertTrue(editedItem.id == fetchedItems[0].id ?? "")
            XCTAssertTrue(editedItem.isDone == fetchedItems[0].isDone)
            XCTAssertTrue(editedItem.title == fetchedItems[0].title ?? "")
            XCTAssertTrue(editedItem.itemDescription == fetchedItems[0].itemDescription ?? "")
            // дата создания не должна изменяться
            XCTAssertTrue(item.creationDate == fetchedItems[0].creationDate!)
            fetchExpectation.fulfill()
        })
        wait(for: [fetchExpectation], timeout: 5)
    }
    
    
    func testDeleteItem() {
        var cancellable: Set<AnyCancellable> = []
        let item: ToDoItem = ToDoItem(
            id: "qwerty",
            isDone: false,
            title: "title",
            itemDescription: "description",
            creationDate: .now
        )
        
        let additionExpectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                additionExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.addItem(item: item)
        wait(for: [additionExpectation], timeout: 1)
        
        let deletionExpectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                deletionExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.deleteItem(item: item)
        wait(for: [deletionExpectation], timeout: 5)
        
        
        let fetchExpectation = XCTestExpectation()
        try? service.fetchItems(completion: { fetchedItems in
            XCTAssertTrue(fetchedItems.count == 0)
            fetchExpectation.fulfill()
        })
        wait(for: [fetchExpectation], timeout: 5)
    }
    
    func testToggleItem() {
        var cancellable: Set<AnyCancellable> = []
        let item: ToDoItem = ToDoItem(
            id: "qwerty",
            isDone: false,
            title: "title",
            itemDescription: "description",
            creationDate: .now
        )
        
        let additionExpectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                additionExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.addItem(item: item)
        wait(for: [additionExpectation], timeout: 1)
        
        let toggleExpectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                toggleExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        try? service.toggleItem(item: item)
        wait(for: [toggleExpectation], timeout: 5)
        
        
        let fetchExpectation = XCTestExpectation()
        try? service.fetchItems(completion: { fetchedItems in
            XCTAssertTrue(fetchedItems.count == 1)
            XCTAssertTrue(item.id == fetchedItems[0].id ?? "")
            XCTAssertTrue(item.isDone == !fetchedItems[0].isDone)
            XCTAssertTrue(item.title == fetchedItems[0].title ?? "")
            XCTAssertTrue(item.itemDescription == fetchedItems[0].itemDescription ?? "")
            XCTAssertTrue(item.creationDate == fetchedItems[0].creationDate ?? .distantPast)
            fetchExpectation.fulfill()
        })
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testAddItem() {
        var cancellable: Set<AnyCancellable> = []
        let item: ToDoItem = ToDoItem(
            id: "qwerty",
            isDone: false,
            title: "title",
            itemDescription: "description",
            creationDate: .now
        )
        let additionExpectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                additionExpectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.addItem(item: item)
        wait(for: [additionExpectation], timeout: 1)
        
        let fetchExpectation = XCTestExpectation()
        try? service.fetchItems(completion: { fetchedItems in
            XCTAssertTrue(fetchedItems.count == 1)
            XCTAssertTrue(item.id == fetchedItems[0].id ?? "")
            XCTAssertTrue(item.isDone == fetchedItems[0].isDone)
            XCTAssertTrue(item.title == fetchedItems[0].title ?? "")
            XCTAssertTrue(item.itemDescription == fetchedItems[0].itemDescription ?? "")
            XCTAssertTrue(item.creationDate == fetchedItems[0].creationDate ?? .distantPast)
            fetchExpectation.fulfill()
        })
        wait(for: [fetchExpectation], timeout: 5)
    }
    
    func testNotification() async throws {
        var cancellable: Set<AnyCancellable> = []
        let expectation = XCTestExpectation()
        let _ = service.operationCompletion
            .sink { _ in
                XCTAssertTrue(true)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        service.addItem(item: ToDoItem(isDone: false, title: "", itemDescription: "", creationDate: .now))
        await fulfillment(of: [expectation])
    }
    
    func testEmptyStorage() {
        let expectation = XCTestExpectation()
        try? service.fetchItems { fetchedItems in
            XCTAssert(fetchedItems.count == 0)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}

