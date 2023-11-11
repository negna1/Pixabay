//
//  Registration.Constant.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 10.11.23.
//

import Foundation

extension RegistrationViewModel {
    enum Constant {
        static let header = "Registration"
        static let minAge = 18
        static let maxAge = 88
        static let passwordWarning = "Password should contain more than 6 and less than 12 characters"
        static let mailWarning =  "Please write correct email"
    }
}
