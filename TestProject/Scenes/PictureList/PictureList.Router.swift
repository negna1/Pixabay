//
//  PictureList.Router.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 10.11.23.
//

import NetworkLayer
import Resolver
import UIKit

protocol PictureListRouterProtocol {
    func navigateToDetails(hit: Hit)
    func getNavigation() -> UINavigationController?
}

final class PictureListRouter: PictureListRouterProtocol {
    private weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func navigateToDetails(hit: Hit) {
        let vc: PictureDetailsViewController = Resolver.resolve(args: hit)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func getNavigation() -> UINavigationController? {
        navigation
    }
}
