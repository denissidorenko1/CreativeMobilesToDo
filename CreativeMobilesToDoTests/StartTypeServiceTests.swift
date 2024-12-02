import XCTest
@testable import CreativeMobilesToDo

final class StartTypeServiceTests: XCTestCase {
    var service: StartTypeService!

    override func setUpWithError() throws {
        service = StartTypeService()
    }

    override func tearDownWithError() throws {
        service = nil
    }

    func testFirstLaunch() throws {
        service.resetStatus()
        let expectedFirstLaunchType = AppLaunchType.firstTimeLaunch
        XCTAssertTrue(expectedFirstLaunchType == service.launchType)
    }
    
    func testSecondLaunch() throws {
        service = nil
        service = StartTypeService()
        let expectedSecondLaunchType = AppLaunchType.subsequentLaunch
        XCTAssertTrue(expectedSecondLaunchType == service.launchType)
    }
}

fileprivate extension StartTypeService {
    func resetStatus() {
        UserDefaults.standard.removeObject(forKey: "startupKey")
    }
}
