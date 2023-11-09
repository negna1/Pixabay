//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 03.11.23.
//

import Foundation

extension BorderedTextField {
    public struct ActionType {
        public var textType: BorderedTextField.TextType
        public var text: String
        public var hasEndedEdit: Bool
        public var textfield: BorderedTextField
    }
    
    public struct Model:  Hashable {
        public static func == (lhs: BorderedTextField.Model, rhs: BorderedTextField.Model) -> Bool {
            lhs.textType == rhs.textType
        }
        
        public func hash(into hasher: inout Hasher) {
           hasher.combine(textType)
         }
        
        public var textType: BorderedTextField.TextType = .name
        public var textToWrite: String
        public var errorText: String? = nil
        public var placeHolder: String?
        public var didChangeText: ((ActionType) -> ())?
        
        public init(textType: BorderedTextField.TextType = .name,
                    textToWrite: String = "",
                    placeHolder: String? = nil,
                    errorText: String? = nil,
         didChangeText: ((ActionType) -> ())?) {
            self.placeHolder =  placeHolder ?? textType.rawValue
            self.textToWrite = textToWrite
            self.textType = textType
            self.errorText = errorText
            self.didChangeText = didChangeText
        }
    }
}

extension BorderedTextField {
    public enum TextType: String {
        case name
        case lastName
        case username
        case email
        case mobile
        case password
    }
}
