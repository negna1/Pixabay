//
//  LogInCellModelMock.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

import XCTest
@testable import TestProject
import Combine
import Resolver
import Components

extension LogInViewModelTest {
    
    var idle: [RegistrationViewController.CellModelType] {
        [.title("title"),
         .textField(mailModel),
         .textField(passwordModel),
         .datePicker(dateModel),
         .button(buttonModel)
        ].compactMap({$0})
    }
    
    private var dateModel: DatePickerTableCell.CellModel {
        return .init(minAge: 0,
                     maxAge: 1,
                     hasError: false) {_ in
            
        }
    }
    
    private var mailModel: BorderedTextField.Model {
        return .init(textType: .email,
                     textToWrite: "email",
                     errorText: nil) { model in
            
        }
    }
    
    private var passwordModel: BorderedTextField.Model {
        return .init(textType: .password,
                     textToWrite: "password",
                     errorText: nil) { model in
            
        }
    }
    
    private var buttonModel: PrimaryButtonTableCell.CellModel {
        .init(title: "header") {_ in
            
        }
    }
}
