//
//  PictureDetailsViewModel.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Combine
import UIKit
import Components
import Resolver
import NetworkLayer

protocol PictureDetailsViewModelType {
    func transform(input: PictureDetailsViewModelInput) -> PictureDetailsViewModelOutput
}

struct PictureDetailsViewModelInput {
}

typealias PictureDetailsViewModelOutput = AnyPublisher<PictureDetailsState, Never>

enum PictureDetailsState: Equatable {
    case idle([RegistrationViewController.CellModelType])
    case navigationToAuth
}

final class PictureDetailsViewModel: PictureDetailsViewModelType {
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    private let hit: Hit
    
    public init(hit: Hit) {
        self.hit = hit
    }
    
    func transform(input: PictureDetailsViewModelInput) -> PictureDetailsViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let idle: PictureDetailsViewModelOutput = Just(.idle(idle))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return idle.eraseToAnyPublisher()
    }
}

// MARK: - Cell Models
extension PictureDetailsViewModel {
    private var idle: [CellType] {
        [
            CellType.title(Constant.picInfo),
            .iconWithDescription(photoInfoMode),
            CellType.title(Constant.authorInfo),
            .iconWithDescription(authorModel),
        ]
    }

    private var photoInfoMode: IconAndInfoWidget.Model {
        .init(titles: hit.pictureInfos,
              imageURLString: hit.largeImageURL ?? .empty)
    }
    
    private var authorModel: IconAndInfoWidget.Model {
        .init(titles: hit.userInfos,
              imageURLString: hit.userImageURL ?? .empty)
    }
}


