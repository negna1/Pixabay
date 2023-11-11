//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Foundation

// MARK: - PicResponse
public struct PicResponse: Decodable  {
    public let total, totalHits: Int?
    public let hits: [Hit]?
}

// MARK: - Hit
public struct Hit: Decodable, Hashable {
    public init(id: Int? = nil, pageURL: String? = nil, type: String? = nil, tags: String? = nil, previewURL: String? = nil, previewWidth: Int? = nil, previewHeight: Int? = nil, webformatURL: String? = nil, webformatWidth: Int? = nil, webformatHeight: Int? = nil, largeImageURL: String? = nil, imageWidth: Int? = nil, imageHeight: Int? = nil, imageSize: Int? = nil, views: Int? = nil, downloads: Int? = nil, collections: Int? = nil, likes: Int? = nil, comments: Int? = nil, userID: Int? = nil, user: String? = nil, userImageURL: String? = nil) {
        self.id = id
        self.pageURL = pageURL
        self.type = type
        self.tags = tags
        self.previewURL = previewURL
        self.previewWidth = previewWidth
        self.previewHeight = previewHeight
        self.webformatURL = webformatURL
        self.webformatWidth = webformatWidth
        self.webformatHeight = webformatHeight
        self.largeImageURL = largeImageURL
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.imageSize = imageSize
        self.views = views
        self.downloads = downloads
        self.collections = collections
        self.likes = likes
        self.comments = comments
        self.userID = userID
        self.user = user
        self.userImageURL = userImageURL
    }
    
    public let id: Int?
    public let pageURL: String?
    public let type: String?
    public let tags: String?
    public let previewURL: String?
    public let previewWidth, previewHeight: Int?
    public let webformatURL: String?
    public let webformatWidth, webformatHeight: Int?
    public let largeImageURL: String?
    public let imageWidth, imageHeight, imageSize, views: Int?
    public let downloads, collections, likes, comments: Int?
    public let userID: Int?
    public let user: String?
    public let userImageURL: String?
    
    
}

public enum TypeEnum: Decodable {
    case photo
}
