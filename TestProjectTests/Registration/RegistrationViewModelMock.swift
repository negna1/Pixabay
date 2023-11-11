//
//  RegistrationViewModelMock.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 10.11.23.
//

@testable import TestProject
import Combine
import XCTest

class RegistrationViewModelMock: RegistrationViewModelType {
    func getStateSubject() -> PassthroughSubject<TestProject.RegistrationState, Never> {
        return stateSubject
    }
    
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    private var stateSubject = PassthroughSubject<RegistrationState, Never>()
    private var currentDataSource: [CellType] = []
    private var navigation: UINavigationController?
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func transform(input: RegistrationViewModelInput) -> RegistrationViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        
        currentDataSource = idleModels
        let idle: RegistrationViewModelOutput = Just(.idle(currentDataSource))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        return Publishers.Merge(idle, stateSubject).removeDuplicates().eraseToAnyPublisher()
    }
    
    private var idleModels: [CellType] {
        let totalCommission = CellType.title("ola")
        return [totalCommission]
    }
    
}
