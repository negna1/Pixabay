//
//  PictureListViewModelTest.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

import XCTest
@testable import TestProject
import Combine
import Resolver
import NetworkLayer
import Components

final class PictureListViewModelTest: XCTestCase, Resolving {
    private var cancellables: [AnyCancellable] = []
    @Injected var vm: PictureListViewModelType
    var worker: PictureListWorkerMock?
    @Injected var vc: LogInViewController
    @Injected var router: LogInRouterProtocol
    
    var expectedResponse: ErrorType = .urlError
    
    private let selection = PassthroughSubject<RegistrationViewController.CellModelType, Never>()
    override func setUp() {
        super.setUp()
        Resolver.register { PictureListWorkerMock() as PictureListWorkerMock }
        Resolver.register { PictureListViewController()}
        Resolver.register { _, args in
            PictureListViewModel(navigation: args()) as PictureListViewModelType }
        Resolver.register { _, args in
            PictureListRouter(navigation: args()) as PictureListRouterProtocol }
        
        worker = Resolver.resolve(PictureListWorkerMock.self)
    }
    
    func testRegistrationAndExplicitResolution() {
        XCTAssertNotNil(vc)
    }
    
    func testRegistrationAndExplicitResolutionForViewModel() {
        XCTAssertNotNil(vm)
    }
    
    func testRegistrationAndExplicitResolutionForRouter() {
        XCTAssertNotNil(router)
    }
    
    func testRegistrationAndExplicitResolutionForWorker() {
        XCTAssertNotNil(worker)
    }
    
    func testStates() {
        let input = PictureListViewModelInput(selection: selection.eraseToAnyPublisher())
        vm.transform(input: input).sink(receiveValue: {state in
            switch state {
            case .idle(let arr):
                XCTAssertEqual(arr.count, 1)
            default:
                break
            }
        }).store(in: &self.cancellables)
    }
    
    func testWorker() async {
        let expecation = expectation(description: "Service expectation")
        let expected = ErrorType.decoderError
        Task {
           
            let t = await worker?.getImages()
            switch t! {
            case .success(_):
                XCTAssertTrue(false)
            case .failure(let failure):
                expectedResponse = failure
                expecation.fulfill()
            }
        }
        
        
        await waitForExpectations(timeout: 4) { error in
            XCTAssertNil(error)
            XCTAssertEqual(
                expected,
                self.expectedResponse,
                "Error case error"
            )
        }
       
    }
}


