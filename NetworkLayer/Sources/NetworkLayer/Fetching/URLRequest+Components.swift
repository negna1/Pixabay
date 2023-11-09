//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 28.04.23.
//

import Foundation

public enum HTTPMethodType: String {
    case POST
    case GET
    case DELETE
    case PUT
}

public extension URLRequest {
    init(components: URLComponents) {
        guard let url = components.url else {
            self = Self.init(url: URL(string: "error.com")!)
            return
        }
        
        self = Self(url: url)
    }
    
    private func map(_ transform: (inout Self) -> ()) -> Self{
        var request = self
        transform(&request)
        return request
    }
    
    func add(httpMethodType: HTTPMethodType) -> Self {
        map { $0.httpMethod = httpMethodType.rawValue }
    }
    
    func add(body: Bodyable) -> Self {
        map {
            $0.httpBody = body.toBody.percentEncoded()
        }
    }
    
    func add(headers: [String: String]) -> Self {
        map {
            let allHTTPHeaders = $0.allHTTPHeaderFields ??  [:]
            let update = headers.merging(allHTTPHeaders, uniquingKeysWith: {$1})
            $0.allHTTPHeaderFields = update
        }
    }
}
