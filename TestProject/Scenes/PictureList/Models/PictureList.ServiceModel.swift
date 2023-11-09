//
//  PictureList.ServiceModel.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import NetworkLayer

extension PicResponse.ImageAndUser: Hashable {}

extension PicResponse {
    struct ImageAndUser {
        let id: Int
        let iconURL: String
        let author: String
    }
    var imageAndTitleArray: [ImageAndUser] {
        self.hits?.compactMap({$0}).map({ $0.imageAndTitle }).compactMap({$0}) ?? []
    }
}

extension Hit {
    var imageAndTitle: PicResponse.ImageAndUser? {
        guard let iconUrl = self.largeImageURL,
              let author = self.user,
              let id = self.id else { return nil }
        return PicResponse.ImageAndUser(id: id, iconURL: iconUrl, author: author)
    }
    
    var pictureInfos: [String] {
        var infos = [String]()
        if let imageSizeStr = imageSize?.description {
            infos.append("Picture size - \(imageSizeStr)")
        }
        if let type = type {
            infos.append("Picture types - \(type)")
        }
        
        if let tags = tags {
            infos.append("Picture tags - \(tags)")
        }
        return infos
    }
    
    var userInfos: [String] {
        var infos = [String]()
        if let likes = likes?.description {
            infos.append("Likes - \(likes)")
        }
        if let comments = comments?.description {
            infos.append("Comments - \(comments)")
        }
        if let collections = collections?.description {
            infos.append("Collections - \(collections)")
        }
        if let downloads = downloads?.description {
            infos.append("Downloads - \(downloads)")
        }
        return infos
    }
}
