//
//  Feed.swift
//  ZAFeed
//
//  Created by tringuyen3297 on 25/03/2022.
//

import Foundation

struct RequestTokenResponse: Decodable {
    let access_token: String
    let token_type: String
}

struct ImageUrls: Decodable {
    let thumb: String
}

struct User: Decodable {
    let name: String
}

class Feed: Decodable {
    let id: String
    var likes: Int
    var liked_by_user: Bool
    let urls: ImageUrls
    let user: User
}
