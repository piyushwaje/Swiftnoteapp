//
//  taglistview.swift
//  noteapp
//
//  Created by piyush sakharam waje on 01/02/25.
//
import SwiftData
import SwiftUI

struct TagListView: View {
    @Environment(\.modelContext) private var context
    @Query( sort : \Tag.name , order: .reverse) var allTags : [Tag]
    @State var TagText : String = ""
    var body: some View {
        List{
            Section{
                DisclosureGroup("Create a Tag"){
                    TextField("Enter a Text ", text: $TagText ,axis: .vertical ).lineLimit(2...4)
                    Button("save"){
                        createTag()
                    }
                }
            }
            Section{
                if allTags.isEmpty{
                    ContentUnavailableView("you don't have Tags yet" ,systemImage : "tag")
                }
                else{
                    ForEach(allTags){
                        
                        tag in
                        if tag.notes.count > 0 {
                            DisclosureGroup("\(tag.name)(\(tag.name.count))"){
                                ForEach(tag.notes){
                                    note in
                                    Text(note.content)
                                }
                                .onDelete{
                                    indexSet in
                                    indexSet.forEach{
                                        index in
                                        context.delete(tag.notes[index])
                                    }
                                    try? context.save()
                                }
                            }
                        }
                        else{
                            Text(tag.name)
                        }
                       
                    }
                    .onDelete{
                        indexSet in indexSet.forEach{index in context.delete(allTags[index])}
                        try? context.save()
                    }
                }
            }
        }
    }
    func createTag(){
        let tag = Tag(id: UUID().uuidString, name: TagText ,notes: [])
        context.insert(tag)
        try? context.save()
        TagText = ""
    }
}

#Preview {
    TagListView()
}
