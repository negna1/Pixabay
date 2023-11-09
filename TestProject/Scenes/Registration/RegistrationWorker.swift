//  
//  RegistrationWorkerswift.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import NetworkLayer
import Resolver
import Foundation

protocol RegistrationWorkerProtocol {
    func saveUser(mail: String, password: String, date: Date?) async -> String
}

final class RegistrationWorker: RegistrationWorkerProtocol {
    @Injected private var localUserService: LocalUsersDataProtocol
    
    public init() {}
    
    func saveUser(mail: String, password: String, date: Date?) async -> String {
        let user = UsersResponseItem(id: UUID().uuidString, mail: mail, password: password, birthDate: date)
        return await localUserService.saveUser(object: user)
    }
}
