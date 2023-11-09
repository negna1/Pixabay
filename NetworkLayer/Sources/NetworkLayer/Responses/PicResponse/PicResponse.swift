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
