//
//  PictureList.ViewModel.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Combine
import UIKit
import Components
import Resolver
import NetworkLayer

protocol PictureListViewModelType {
    func transform(input: PictureListViewModelInput) -> PictureListViewModelOutput
}

struct PictureListViewModelInput {
    let selection: AnyPublisher<RegistrationViewController.CellModelType, Never>
}

typealias PictureListViewModelOutput = AnyPublisher<PictureListState, Never>

enum PictureListState: Equatable {
    case idle([RegistrationViewController.CellModelType])
    case isLoading(Bool)
}

final class PictureListViewModel: PictureListViewModelType {
    private typealias CellType = RegistrationViewController.CellModelType
    private var cancellables: [AnyCancellable] = []
    
    private var stateSubject = PassthroughSubject<PictureListState, Never>()
    private var currentDataSource: [CellType] = []
    @Injected private var pictureListWorker: PictureListWorkerProtocol
    private var router: PictureListRouterProtocol
    
    
    private var picAndAuthors: [PicResponse.ImageAndUser] = []
    private var hits: [Hit] = []
    public init(navigation: UINavigationController?) {
        self.router = Resolver.resolve(args: navigation)
    }
    
    func transform(input: PictureListViewModelInput) -> PictureListViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        callPictureListService()
        selectionSink(input: input)
        let idle: PictureListViewModelOutput = Just(.idle(idle))
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
        
        return Publishers.Merge(idle, stateSubject).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func callPictureListService() {
        Task {
            let result = await self.pictureListWorker.getImages()
            switch result {
            case .success(let response):
                capturePicturesSuccess(response: response)
            case .failure(let failure):
                capturePicturesFail(failure: failure)
            }
        }
    }
    
    private func capturePicturesSuccess(response: PicResponse) {
        stateSubject.send(.isLoading(false))
        hits = response.hits ?? []
        picAndAuthors = response.imageAndTitleArray
        stateSubject.send(.idle(idle))
    }
    
    private func capturePicturesFail(failure: ErrorType) {
        stateSubject.send(.isLoading(false))
        let cellModels: [CellType] = [.title(failure.description ?? failure.localizedDescription)]
        self.stateSubject.send(.idle(cellModels))
    }
    
    private func selectionSink(input: PictureListViewModelInput) {
        input.selection.sink { cellType in
            switch cellType {
            case .imageWithTitle(let imageWithAuthor):
                guard let hit = self.hits.filter({$0.id == imageWithAuthor.id}).first else { return }
                self.router.navigateToDetails(hit: hit)
            default:
                break
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Cell Models
extension PictureListViewModel {
    private var idle: [CellType] {
        [CellType.title(Constant.header)] + models
    }
    
    private var models: [CellType] {
        picAndAuthors.map({CellType.imageWithTitle($0)})
    }
}

