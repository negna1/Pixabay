//
//  LogInViewModelMock.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

@testable import TestProject
import Combine
import XCTest

class LogInViewModelMock: LogInViewModelType {
    func getStateSubject() -> PassthroughSubject<LogInState, Never> {
        return stateSubject
    }
    
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    private var stateSubject = PassthroughSubject<LogInState, Never>()
    private var currentDataSource: [CellType] = []
    private var navigation: UINavigationController?
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func transform(input: LogInViewModelInput) -> LogInViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        currentDataSource = idleModels
        let idle: LogInViewModelOutput = Just(.idle(currentDataSource))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        return Publishers.Merge(idle, stateSubject).removeDuplicates().eraseToAnyPublisher()
    }
    
    private var idleModels: [CellType] {
        [.title("ola")]
    }
    
}

