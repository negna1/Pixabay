//  
//  RegistrationConfigurator.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import Resolver
import NetworkLayer

extension Resolver {
    public static func registerRegitrationServices() {
        defaultScope = .graph
        register { RegistrationWorker() as RegistrationWorkerProtocol }
//        register { RegistrationViewModel() as RegistrationViewModelType }
        register { _, args in
            RegistrationViewModel(navigation: args()) as RegistrationViewModelType }
        register { RegistrationViewController() }
    }
}
