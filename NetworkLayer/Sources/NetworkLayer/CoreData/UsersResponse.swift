//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 07.11.23.
//

import Foundation

public struct UsersResponse: Codable {
    public let items: [UsersResponseItem]?
}

// MARK: - Item
public struct UsersResponseItem: Codable {
    public init(id: String? = nil, mail: String? = nil, password: String? = nil, birthDate: Date? = nil) {
        self.id = id
        self.mail = mail
        self.password = password
        self.birthDate = birthDate
    }
    
    public let id: String?
    public let mail: String?
    public let password: String?
    public let birthDate: Date?
}
