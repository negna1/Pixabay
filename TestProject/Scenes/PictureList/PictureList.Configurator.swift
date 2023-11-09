//
//  PictureList.Configurator.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Resolver
import NetworkLayer

extension Resolver {
    public static func pictureListRegitrationServices() {
        register { PictureListWorker() as PictureListWorkerProtocol }
        register { PictureListViewModel() as PictureListViewModelType }
        register { PictureListViewController() }
    }
}
