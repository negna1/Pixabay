//
//  String+Extension.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 08.11.23.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        self.count < 12 && self.count >= 6
    }
    
    static let empty = ""
}
