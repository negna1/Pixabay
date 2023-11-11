//
//  LogIn.ViewModel.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 08.11.23.
//

import Combine
import UIKit
import Components
import Resolver
import NetworkLayer

protocol LogInViewModelType {
    func transform(input: LogInViewModelInput) -> LogInViewModelOutput
    func getStateSubject() -> PassthroughSubject<LogInState, Never> 
}

struct LogInViewModelInput {
}

typealias LogInViewModelOutput = AnyPublisher<LogInState, Never>

enum LogInState: Equatable {
    case idle([RegistrationViewController.CellModelType])
}

final class LogInViewModel: LogInViewModelType {
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    
    private var stateSubject = PassthroughSubject<LogInState, Never>()
    private var currentDataSource: [CellType] = []
    @Injected private var loginWorker: LogInWorkerProtocol
    private var mail: String = .empty
    private var password: String = .empty
    private var needErrorState: Bool = false
    private var router: LogInRouterProtocol
    
    private var isValid: Bool { password.isValidPassword && mail.isValidEmail }
    // MARK: -  Action handlers
    private lazy var registerAction: ((PrimaryButtonTableCell) -> ()) = { button in
        self.router.navigateToRegistration()
    }
    
    private lazy var logInAction: ((PrimaryButtonTableCell) -> ()) = { button in
        
        self.needErrorState = true
        guard self.isValid  else {
            self.stateSubject.send(.idle(self.idle))
            return
        }
        self.callLoginService()
    }
    
    public init(navigation: UINavigationController?) {
        self.router = Resolver.resolve(args: navigation)
    }
    
    func transform(input: LogInViewModelInput) -> LogInViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let idle: LogInViewModelOutput = Just(.idle(idle))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return Publishers.Merge(idle, stateSubject).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func callLoginService() {
        Task {
            let result = await self.loginWorker.loginUser(mail:self.mail, password: self.password)
            switch result {
            case .success(_):
                router.navigateToPictureList()
            case .failure(let failure):
                stateSubject.send(.idle(idle + [.title(failure.description ?? failure.localizedDescription)]))
            }
        }
    }
}

// MARK: - Cell Models
extension LogInViewModel {
    private var idle: [CellType] {
        [CellType.title(Constant.header),
         CellType.textField(mailModel),
         CellType.textField(passwordModel),
         CellType.button( authorizationButton),
         CellType.title(Constant.or),
         CellType.button(buttonModel)
        ]
    }
    
    private var mailModel: BorderedTextField.Model {
        let errorText = !needErrorState ? nil :
        mail.isValidEmail ? nil : Constant.mailWarning
        return .init(textType: .email,
                     textToWrite: mail,
                     errorText: errorText ) { model in
            self.mail = model.text
        }
    }
    
    private var passwordModel: BorderedTextField.Model {
        let errorText = !needErrorState ? nil :
        password.isValidPassword ? nil : Constant.passwordWarning
        return .init(textType: .password,
                     textToWrite: password,
                     errorText: errorText) { model in
            self.password = model.text
        }
    }
    
    private var buttonModel: PrimaryButtonTableCell.CellModel {
        .init(title: Constant.registration, tap: registerAction)
    }
    
    private var authorizationButton: PrimaryButtonTableCell.CellModel {
        .init(title: Constant.header, tap: logInAction)
    }
    
    func getStateSubject() -> PassthroughSubject<LogInState, Never> {
        return stateSubject
    }
    
}
