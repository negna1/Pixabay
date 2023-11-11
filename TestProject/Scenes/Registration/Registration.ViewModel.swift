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
    func getStateSubject() -> PassthroughSubject<RegistrationState, Never>
}

struct RegistrationViewModelInput {}

typealias RegistrationViewModelOutput = AnyPublisher<RegistrationState, Never>

enum RegistrationState: Equatable {
    case idle([RegistrationViewController.CellModelType])
}

final class RegistrationViewModel: RegistrationViewModelType {
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    private var stateSubject = PassthroughSubject<RegistrationState, Never>()
    @Injected private var mainWorker: RegistrationWorkerProtocol
    
    private var mail: String = .empty
    private var password: String = .empty
    private var birthDate: Date? = nil
    private var needErrorState: Bool = false
    private var router: LogInRouterProtocol
    private var isValid: Bool { password.isValidPassword && mail.isValidEmail }
    // MARK: -  Action handlers
    private lazy var registerAction: ((PrimaryButtonTableCell) -> ()) = { button in
        self.needErrorState = true
        guard self.isValid ,
              let _ = self.birthDate else {
            self.stateSubject.send(.idle(self.idle))
            return
        }
        self.callRegister()
    }
    
    private lazy var dateAction: ((Date) -> ()) = { date in
        self.birthDate = date
    }
    
    public init(navigation: UINavigationController?) {
        self.router = Resolver.resolve(args: navigation)
    }
    
    func transform(input: RegistrationViewModelInput) -> RegistrationViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let idle: RegistrationViewModelOutput = Just(.idle(idle))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return Publishers.Merge(idle, stateSubject).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func callRegister() {
        Task {
            let response = await self.mainWorker.saveUser(mail: self.mail,
                                                          password: self.password,
                                                          date: birthDate)
            switch response {
            case .success(_):
                router.navigateToPictureList()
            case .failure(let failure):
                stateSubject.send(.idle(idle + [.title(failure.description ?? failure.localizedDescription)]))
            }
        }
    }
}

// MARK: - Cell Models
extension RegistrationViewModel {
    private var idle: [CellType] {
        [CellType.title(Constant.header),
         CellType.textField(mailModel),
         CellType.textField(passwordModel),
         CellType.datePicker(dateModel),
         CellType.button(buttonModel)
        ].compactMap({$0})
    }
    
    private var dateModel: DatePickerTableCell.CellModel {
        let hasError = !needErrorState ? false :
        birthDate == nil
        return .init(minAge: Constant.minAge,
                     maxAge: Constant.maxAge,
                     hasError: hasError,
                     dateChanged: dateAction)
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
        .init(title: Constant.header, tap: registerAction)
    }
    
    func getStateSubject() -> PassthroughSubject<RegistrationState, Never> {
        return stateSubject
    }
    
}
