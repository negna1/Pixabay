//
//  LogIn.Configurator.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 08.11.23.
//

import Resolver
import NetworkLayer

extension Resolver {
    public static func loginRegitrationServices() {
        defaultScope = .graph
        register { LocalUsersData() as LocalUsersDataProtocol }
        register { LogInWorker() as LogInWorkerProtocol }
        register { LogInViewModel() as LogInViewModelType }
        register { LogInViewController() }
    }
}
