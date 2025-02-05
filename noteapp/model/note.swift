//
//  note.swift
//  noteapp
//
//  Created by piyush sakharam waje on 01/02/25.
//


import Foundation
import SwiftData

@Model
class Note{
    @Attribute(.unique) var id : String?
    var content : String
    var createdAt : Date
    
    @Relationship(inverse: \Tag.notes) var tags : [Tag]
    
    init(id: String, content: String, createdAt: Date, tags: [Tag]) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.tags = tags
    }
    
}
