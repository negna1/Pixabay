//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 28.04.23.
//

import Foundation


public extension URLComponents {
    
    init(scheme: String = "https",
                host: String,
                path: String,
                queryItems: [URLQueryItem]? = nil) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        self = components
    }
    
    init(scheme: String = "https",
                host: HostTypable,
                path: PathTypable,
                queryItems: [URLQueryItem]? = nil) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host.host
        components.path = path.path
        components.queryItems = queryItems
        self = components
    }
}

public protocol Bodyable {
    var toBody: [String: Any] {get set}
}

public protocol HostTypable {
    var host: String { get }
}

public protocol PathTypable {
    var path: String { get }
}



