//
//  LogInViewModelTest.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

import XCTest
@testable import TestProject
import Combine
import Resolver
import Components

final class LogInViewModelTest: XCTestCase {
    private var cancellables: [AnyCancellable] = []
    
    override func setUp() {
           super.setUp()
        Resolver.register { LogInViewController() as LogInViewController }
        Resolver.register { _, args in
            LogInViewModel(navigation: args()) as LogInViewModelType }
        
    }
    
    override func setUpWithError() throws {
        Resolver.register { LogInViewController() as LogInViewController }
        Resolver.register { _, args in
            LogInViewModel(navigation: args()) as LogInViewModelType }
       
    }
    
    func testRegistrationAndExplicitResolution() {
            Resolver.register { LogInViewController() }
            let session: LogInViewController? = Resolver.resolve(LogInViewController.self)
            XCTAssertNotNil(session)
        }
    
    func testRegistrationAndExplicitResolutionForViewModel() {
        Resolver.register { LogInViewController() as LogInViewController }
        Resolver.register { _, args in
            LogInViewModel(navigation: args()) as LogInViewModelType }
        @Injected var vm: LogInViewModelType
        XCTAssertNotNil(vm)
    }
    
    func testRegistrationAndExplicitResolutionForRouter() {
        Resolver.loginRegitrationServices()
        @Injected var router: LogInRouterProtocol
        XCTAssertNotNil(router)
    }
    
    func testStates() {
        Resolver.register { LogInViewController() as LogInViewController }
        Resolver.register { _, args in
            LogInViewModel(navigation: args()) as LogInViewModelType }
        @Injected var vm: LogInViewModelType
        let input = LogInViewModelInput()
        vm.transform(input: input).sink(receiveValue: {state in
            switch state {
            case .idle(let arr):
                XCTAssertEqual(arr.count, 6)
            }
        }).store(in: &self.cancellables)
    }
    
    func testCellModelTypes() {
        Resolver.register { LogInViewController() as LogInViewController }
        Resolver.register { _, args in
            LogInViewModel(navigation: args()) as LogInViewModelType }
        @Injected var vm: LogInViewModelType
        let cellModels = idle
        let output: LogInViewModelOutput = Just(.idle(cellModels))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        output.sink { state in
            switch state {
            case .idle(let types):
                XCTAssertEqual(types, cellModels)
            }
        }.store(in: &cancellables)
    }
    
    func testNavigation() {
        Resolver.loginRegitrationServices()
        @Injected var vc: LogInViewController
        @Injected var router: LogInRouterProtocol
        vc.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(router.getNavigation()?.viewControllers.count ?? 0, 2)
        }
    }
}

