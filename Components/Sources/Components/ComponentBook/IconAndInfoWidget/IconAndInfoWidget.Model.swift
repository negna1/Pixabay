//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Foundation

extension IconAndInfoWidget {
    public struct Model:  Hashable {
        public static func == (lhs: IconAndInfoWidget.Model, rhs: IconAndInfoWidget.Model) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
           hasher.combine(id)
         }
        
        public var id: UUID = UUID()
        public let titles: [String]
        public let imageURLString: String
        public init(titles: [String], imageURLString: String) {
            self.titles =  titles
            self.imageURLString = imageURLString
        }
    }
}
