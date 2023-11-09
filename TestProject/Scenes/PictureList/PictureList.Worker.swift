//
//  PictureList.Worker.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import NetworkLayer
import Resolver
import Foundation

protocol PictureListWorkerProtocol {
    func getImages() async -> Result<PicResponse, ErrorType>
}

final class PictureListWorker: PictureListWorkerProtocol {
    @Injected private var networkLayer: NetworkLayer
    
    public init() {}
    func getImages() async -> Result<PicResponse, ErrorType> {
        return await networkLayer.fetchAsync(for: .pictures(queries: [.accessKey]), with: PicResponse.self)
    }
}
