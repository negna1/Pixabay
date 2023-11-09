//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Foundation

extension ImageWithTitle {
    public struct Model:  Hashable {
        public static func == (lhs: ImageWithTitle.Model, rhs: ImageWithTitle.Model) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
           hasher.combine(id)
         }
        
        public var id: UUID = UUID()
        public let title: String
        public let imageURLString: String
        public init(title: String, imageURLString: String) {
            self.title =  title
            self.imageURLString = imageURLString
        }
    }
}
