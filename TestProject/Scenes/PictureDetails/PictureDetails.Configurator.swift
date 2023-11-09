//
//  PictureDetails.Configurator.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Resolver
import NetworkLayer

extension Resolver {
    public static func pictureDetailsRegitrationServices() {
        register { _, args in
            PictureDetailsViewModel(hit: args()) as PictureDetailsViewModelType }
        register { _, args in
            PictureDetailsViewController(hit: args()) as PictureDetailsViewController }
    }
}

