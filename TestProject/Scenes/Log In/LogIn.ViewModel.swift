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
}

struct LogInViewModelInput {
}

typealias LogInViewModelOutput = AnyPublisher<LogInState, Never>

enum LogInState: Equatable {
    case idle([RegistrationViewController.CellModelType])
    case navigationToAuth
}

final class LogInViewModel: LogInViewModelType {
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    
    private var stateSubject = PassthroughSubject<LogInState, Never>()
    private var currentDataSource: [CellType] = []
    @Injected private var loginWorker: LogInWorkerProtocol
    var users = [UsersResponseItem]()
    private var mail: String = ""
    private var password: String = ""
    private var needErrorState: Bool = false
    
    private var isValid: Bool { password.isValidPassword && mail.isValidEmail }
    // MARK: -  Action handlers
    private lazy var registerAction: ((PrimaryButtonTableCell) -> ()) = { button in
        self.stateSubject.send(.navigationToAuth)
    }
    
    private lazy var logInAction: ((PrimaryButtonTableCell) -> ()) = { button in
        
        self.needErrorState = true
        guard self.isValid  else {
            self.stateSubject.send(.idle(self.idle))
            return
        }
        self.callLoginService()
    }
    
    public init() {}
    
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
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

// MARK: - Cell Models
extension LogInViewModel {
    private var idle: [CellType] {
        [CellType.title("Log In"),
         CellType.textField(mailModel),
         CellType.textField(passwordModel),
         CellType.button( authorizationButton),
         CellType.title("OR"),
         CellType.button(buttonModel)
        ]
    }
    
    private var mailModel: BorderedTextField.Model {
        let errorText = !needErrorState ? nil :
        mail.isValidEmail ? nil : "Please write correct email"
        return .init(textType: .email,
                     textToWrite: mail,
                     errorText: errorText ) { model in
            self.mail = model.text
        }
    }
    
    private var passwordModel: BorderedTextField.Model {
        let errorText = !needErrorState ? nil :
        password.isValidPassword ? nil : "Password should contain more than 6 and less than 12 characters"
        return .init(textType: .password,
                     textToWrite: password,
                     errorText: errorText) { model in
            self.password = model.text
        }
    }
    
    private var buttonModel: PrimaryButtonTableCell.CellModel {
        .init(title: "Register", tap: registerAction)
    }
    
    private var authorizationButton: PrimaryButtonTableCell.CellModel {
        .init(title: "Log In ", tap: logInAction)
    }
}
