//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 01.05.23.
//

import Foundation

extension URLComponents {
    public static func pictures(queries: [URLQueryItem])-> Self {
        URLComponents(host: HostType.pixabay,
                             path: PathType.pictures,
                             queryItems: queries)
    }
}

extension URLRequest {
    public static func pictures(queries: [URLQueryItem])-> Self {
        URLRequest(components: .pictures(queries: queries))
    }
}

extension URLQueryItem {
    public static var accessKey: Self {
        URLQueryItem(name: "key", value: APIKEY)
    }
}
