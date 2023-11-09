//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 05.05.23.
//

import Foundation


struct ExampleModel: Codable, Equatable, Hashable {
    let login: String
    let id: Int
    let nodeID: String
    let url, reposURL, eventsURL, hooksURL: String
    let issuesURL: String
    let membersURL, publicMembersURL: String
    let avatarURL: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case url
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case hooksURL = "hooks_url"
        case issuesURL = "issues_url"
        case membersURL = "members_url"
        case publicMembersURL = "public_members_url"
        case avatarURL = "avatar_url"
        case description
    }
     
    static func ==(lhs: ExampleModel, rhs: ExampleModel) -> Bool {
        return lhs.id == rhs.id && lhs.nodeID == rhs.nodeID && lhs.login == rhs.login
    }
}

typealias ExampleModels = [ExampleModel]
