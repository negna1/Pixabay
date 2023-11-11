//
//  RegistrationViewModelTest.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

import XCTest
@testable import TestProject
import Combine
import Resolver
import Components

final class RegistrationViewModelTest: XCTestCase {
    private var cancellables: [AnyCancellable] = []
    
    override func setUp() {
           super.setUp()
        Resolver.register { RegistrationViewController() as RegistrationViewController }
        Resolver.register { _, args in
            RegistrationViewModel(navigation: args()) as RegistrationViewModelType }
        
    }
    
    override func setUpWithError() throws {
        Resolver.register { RegistrationViewController() as RegistrationViewController }
        Resolver.register { _, args in
            RegistrationViewModel(navigation: args()) as RegistrationViewModelType }
       
    }
    
    func testRegistrationAndExplicitResolution() {
            Resolver.register { RegistrationViewController() }
            let session: RegistrationViewController? = Resolver.resolve(RegistrationViewController.self)
            XCTAssertNotNil(session)
        }
    
    func testRegistrationAndExplicitResolutionForViewModel() {
        Resolver.register { RegistrationViewController() as RegistrationViewController }
        Resolver.register { _, args in
            RegistrationViewModel(navigation: args()) as RegistrationViewModelType }
        @Injected var vm: RegistrationViewModelType
        XCTAssertNotNil(vm)
    }
    
    func testStates() {
        Resolver.register { RegistrationViewController() as RegistrationViewController }
        Resolver.register { _, args in
            RegistrationViewModel(navigation: args()) as RegistrationViewModelType }
        @Injected var vm: RegistrationViewModelType
        let input = RegistrationViewModelInput()
        vm.transform(input: input).sink(receiveValue: {state in
            switch state {
            case .idle(let arr):
                XCTAssertEqual(arr.count, 5)
            }
        }).store(in: &self.cancellables)
    }
    
    func testCellModelTypes() {
        Resolver.register { RegistrationViewController() as RegistrationViewController }
        Resolver.register { _, args in
            RegistrationViewModel(navigation: args()) as RegistrationViewModelType }
        @Injected var vm: RegistrationViewModelType
        let cellModels = idle
        let output: RegistrationViewModelOutput = Just(.idle(cellModels))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        output.sink { state in
            switch state {
            case .idle(let types):
                XCTAssertEqual(types, cellModels)
            }
        }.store(in: &cancellables)
    }
}
