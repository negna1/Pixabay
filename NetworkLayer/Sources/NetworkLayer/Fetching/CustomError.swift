//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 28.04.23.
//

import Foundation

public enum ErrorType: Error, Equatable {
    case urlError
    case noData
    case decoderError
    case httpStatusCode(Int)
    case error(String)
    case internetError
    
    public var description: String? {
        switch self {
        case .error(let loc):
            return loc
        case .internetError:
            return "Please check your internet connection"
        case .urlError:
            return "There is not such URL"
        default:
            return nil
        }
    }
}
