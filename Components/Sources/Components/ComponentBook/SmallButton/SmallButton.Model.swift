//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import Foundation

extension SmallButton {
    public struct Model:  Hashable {
        public static func == (lhs: SmallButton.Model, rhs: SmallButton.Model) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
           hasher.combine(id)
         }
        
        public var id: UUID = UUID()
        public var title: String
        public var didTap: ((SmallButton) -> ())?
        
        public init(title: String,
                    didTap: ((SmallButton) -> ())? ) {
            self.title =  title
            self.didTap = didTap
        }
    }
}
