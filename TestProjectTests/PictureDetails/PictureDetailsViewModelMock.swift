//
//  PictureDetailsViewModelMock.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

@testable import TestProject
import Combine
import XCTest

class PictureDetailsViewModelMock: PictureDetailsViewModelType {
    
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    private var navigation: UINavigationController?
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func transform(input: PictureDetailsViewModelInput) -> PictureDetailsViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let idle: PictureDetailsViewModelOutput = Just(.idle([.title("ola")]))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        return idle.eraseToAnyPublisher()
    }
    
    private var idleModels: [CellType] {
        [.title("ola")]
    }
    
}
