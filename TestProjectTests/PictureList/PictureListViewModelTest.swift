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
import Components

final class PictureListViewModelTest: XCTestCase {
    private var cancellables: [AnyCancellable] = []
    @Injected var vm: PictureListViewModelType
    @Injected var worker: PictureListWorkerProtocol
    @Injected var vc: LogInViewController
    @Injected var router: LogInRouterProtocol
    
    private let selection = PassthroughSubject<RegistrationViewController.CellModelType, Never>()
    override func setUp() {
        super.setUp()
        Resolver.register { PictureListWorkerMock() as PictureListWorkerProtocol }
        Resolver.register { PictureListViewController()}
        Resolver.register { _, args in
            PictureListViewModel(navigation: args()) as PictureListViewModelType }
        Resolver.register { _, args in
            PictureListRouter(navigation: args()) as PictureListRouterProtocol }
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
}


