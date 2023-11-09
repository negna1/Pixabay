//
//  LogIn.Worker.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 08.11.23.
//

import NetworkLayer
import Resolver
import Foundation

protocol LogInWorkerProtocol {
    func loginUser(mail: String, password: String) async -> Result<String, ErrorType>
}

final class LogInWorker: LogInWorkerProtocol {
    @Injected private var localUserService: LocalUsersDataProtocol
    
    public init() {}
    
    func loginUser(mail: String, password: String) async -> Result<String, ErrorType> {
        return await localUserService.getUser(email: mail, password: password)
    }
}

