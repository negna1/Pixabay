//  
//  RegistrationModel.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import Combine
import UIKit
import Components
import Resolver
import NetworkLayer

protocol RegistrationViewModelType {
    func transform(input: RegistrationViewModelInput) -> RegistrationViewModelOutput
}

struct RegistrationViewModelInput {
    
}

typealias RegistrationViewModelOutput = AnyPublisher<RegistrationState, Never>

enum RegistrationState: Equatable {
    case idle([RegistrationViewController.CellModelType])
}

final class RegistrationViewModel: RegistrationViewModelType {
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    private var stateSubject = PassthroughSubject<RegistrationState, Never>()
    @Injected private var mainWorker: RegistrationWorkerProtocol
    
    private var mail: String = ""
    private var password: String = ""
    private var birthDate: Date? = nil
    private var needErrorState: Bool = false
    
    private var isValid: Bool { password.isValidPassword && mail.isValidEmail }
    // MARK: -  Action handlers
    private lazy var registerAction: ((PrimaryButtonTableCell) -> ()) = { button in
        self.needErrorState = true
        guard self.isValid ,
              let _ = self.birthDate else {
             self.stateSubject.send(.idle(self.idleVar))
            return
        }
        self.callRegister()
    }
    
    private lazy var dateAction: ((Date) -> ()) = { date in
        self.birthDate = date
    }
    
    public init() {}
    
    func transform(input: RegistrationViewModelInput) -> RegistrationViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
       
        let idle: RegistrationViewModelOutput = Just(.idle(idleVar))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return Publishers.Merge(idle, stateSubject).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func callRegister() {
        Task {
            await self.mainWorker.saveUser(mail: self.mail,
                                     password: self.password,
                                     date: birthDate)
        }
    }
}

// MARK: - Cell Models
extension RegistrationViewModel {
    private var idleVar: [CellType] {
        [CellType.title("Registration"),
         CellType.textField(mailModel),
         CellType.textField(passwordModel),
         CellType.datePicker(.init(minAge: 18,
                                   maxAge: 88,
                                   hasError: birthDate == nil,
                                   dateChanged: dateAction)),
         CellType.button(buttonModel)
        ].compactMap({$0})
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
}
