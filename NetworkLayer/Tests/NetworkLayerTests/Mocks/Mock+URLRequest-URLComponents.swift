//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 05.05.23.
//

import NetworkLayer
import Foundation

extension URLComponents {
    public static var example: Self {
        URLComponents(host: MockHost().host,
                      path: MockPath().path)
    }
}

extension URLRequest {
    public static var example: Self {
        URLRequest(components: .example)
    }
}

public class MockHost: HostTypable {
    public var host: String = "api.github.com"
}

public class MockPath: PathTypable {
    public var path: String = "/users/hadley/orgs"
}
