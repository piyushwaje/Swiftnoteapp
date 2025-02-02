//
//  tag.swift
//  noteapp
//
//  Created by piyush sakharam waje on 01/02/25.
//

import Foundation
import SwiftData

@Model
class Tag{
    @Attribute(.unique) var id : String?
    var name : String
    
    @Relationship var notes : [Note]
    @Transient var ischecked = false
    init(id: String, name: String, notes: [Note]) {
        self.id = id
        self.name = name
        self.notes = notes
    }
    
  
}
