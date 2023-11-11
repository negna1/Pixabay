//
//  LogIn.Router.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 10.11.23.
//

import NetworkLayer
import Resolver
import UIKit

protocol LogInRouterProtocol {
    func navigateToPictureList()
    func navigateToRegistration()
    func getNavigation() -> UINavigationController?
}

final class LogInRouter: LogInRouterProtocol {
    private weak var navigation: UINavigationController?
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func getNavigation() -> UINavigationController? {
        navigation
    }
    
    func navigateToPictureList() {
        DispatchQueue.main.async {
            let vc: PictureListViewController  = Resolver.resolve()
            self.navigation?.viewControllers.removeAll()
            self.navigation?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToRegistration() {
        DispatchQueue.main.async {
            let vc: RegistrationViewController  = Resolver.resolve()
            self.navigation?.pushViewController(vc, animated: true)
        }
    }
}

