import XCTest
@testable import NetworkLayer

final class NetworkLayerTests: XCTestCase {
    var response: ExampleModels = []
    
    class ReachebilityMock: ReachabilityProtocol {
        func isConnectedToNetwork() -> Bool {
            return false
        }
    }
    
    class ReachebilityMockSuccess: ReachabilityProtocol {
        func isConnectedToNetwork() -> Bool {
            true
        }
    }
    
    func testCoreData() throws {
        let coreData = LocalUsersData()
        coreData.fetchAndRemove(id: "id")
        Task {
            let resp = await coreData.saveUser(object: .init(id: "id"))
            switch resp {
            case .success(let success):
                XCTAssertEqual(success, "User success")
            case .failure(_):
                XCTAssertFalse(true)
            }
        }

    }
    
    func testUsers() {
        let coreData = LocalUsersData()

        Task {
            let users = await coreData.fetchRequest()
            XCTAssertEqual(users.first?.id, "id")
        }
    }
    
    func testInternetError() throws {
        let network = NetworkLayer(reachebility: ReachebilityMock())
        Task {
            let error = await network.fetchAsync(for: .init(components: .init()), with: ExampleModels.self)
            switch error {
            case .success(_):
                XCTAssert(false)
            case .failure(let failure):
                XCTAssertEqual(failure, .internetError)
            }
        }
    }
    
    func testSuccess() async throws {
        let network = NetworkLayer(reachebility: ReachebilityMockSuccess())
        let expected = NetworkLayer().readFromJson(fileName: "example", with: ExampleModels.self)
        let expectation = self.expectation(description: "Waiting for the get crypto  call to complete.")
        
        Task {
           
            let error = await network.fetchAsync(for: .example, with: ExampleModels.self)
            switch error {
            case .success(let success):
                self.response = success
                expectation.fulfill()
            case .failure(_):
                XCTAssert(false)
            }
        }
        
        
        await waitForExpectations(timeout: 4) { error in
            XCTAssertNil(error)
            XCTAssertEqual(
                expected,
                self.response,
                "Error case error"
            )
        }
    }
}


