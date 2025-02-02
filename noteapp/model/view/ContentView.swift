//
//  ContentView.swift
//  noteapp
//
//  Created by piyush sakharam waje on 31/01/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query( sort : \Note.createdAt , order: .reverse) var allNotes : [Note]
    @Query( sort : \Tag.name , order: .forward) var allTags : [Tag]
    @State var noteText : String = ""
    var body: some View {
        List{
            Section{
                DisclosureGroup("Create a note"){
                    TextField("Enter a Text ", text: $noteText ,axis: .vertical ).lineLimit(2...4)
                    DisclosureGroup("Tag With"){
                        if allTags.isEmpty{
                            Text("You don't have any tags yet. Please create one from Tags tab")
                                .foregroundStyle(Color.gray)
                        }
                        ForEach(allTags) { tag in
                            HStack {
                                Text(tag.name)
                                if tag.ischecked {
                                    Spacer()
                                    Image(systemName: "checkmark.circle")
                                        .symbolRenderingMode(.multicolor)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                tag.ischecked.toggle()
                            }
                        }
                    }
                    Button("save"){
                        createNote()
                    }
                    .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            Section{
                if allNotes.isEmpty{
                    ContentUnavailableView("you don't have notes yet" ,systemImage : "note")
                }
                else{
                    ForEach(allNotes){
                        note in VStack(alignment: .leading){
                            
                            Text(note.content)
                            if !note.tags.isEmpty {
                                Text("Tags: " + note.tags.map { $0.name }.joined(separator: ", "))
                                    .font(.caption)
                            }

                            Text(note.createdAt ,style: .time).font(.caption)
                        }
                    }
                    .onDelete{
                        indexSet in indexSet.forEach{index in context.delete(allNotes[index])}
                        try? context.save()
                    }
                }
            }
        }
    }
    func createNote(){
        var tags = [Tag]()
        allTags.forEach{tag in if tag.ischecked{
            tags.append(tag)
            tag.ischecked = false
        }}
        let note = Note(id: UUID().uuidString, content: noteText, createdAt: .now , tags: tags )
        context.insert(note)
        try? context.save()
        noteText = ""
    }
}

#Preview {
    ContentView()
}
