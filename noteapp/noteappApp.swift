//
//  noteappApp.swift
//  noteapp
//
//  Created by piyush sakharam waje on 31/01/25.
//
import SwiftData
import SwiftUI


@main
struct noteappApp: App {
    @State var noteSearchText = ""
    @State var noteSortBy = NoteSortBy.createdAt
    @State var noteOrderBy = OrderBy.descending
    
    @State var tagSearchText = ""
    @State var tagOrderBy = OrderBy.ascending
    var body: some Scene {
        WindowGroup {
            TabView{
                notelist
                taglist
            }
                .modelContainer(for: [Note.self
                                      ,Tag.self])
              
        }
        
    }
    var notelist : some View{
        NavigationStack{
            ContentView(_allNotes: noteListQuery)
                .searchable(text: $noteSearchText, prompt: "Search")
                #if os(macOS)
                .textCase(.none)
                #else
                .textInputAutocapitalization(.never)
                #endif
                .navigationTitle("Notes")
                .toolbar {
                    ToolbarItemGroup {
                        Menu {
                            Picker("Sort by", selection: $noteSortBy) {
                                ForEach(NoteSortBy.allCases) {
                                    Text($0.text).id($0)
                                }
                            }
                        } label: {
                            Label(noteSortBy.text, systemImage: "line.horizontal.3.decrease.circle")
                        }
                        
                        Menu {
                            Picker("Order by", selection: $noteOrderBy) {
                                ForEach(OrderBy.allCases) {
                                    Text($0.text).id($0)
                                }
                            }
                        } label: {
                            Label(noteOrderBy.text, systemImage: "arrow.up.arrow.down")
                        }
                    }
                }
        }
        .tabItem{ Label("Notes", systemImage: "note")}
       
    }
    var noteListQuery: Query<Note, [Note]> {
        let sortOrder: SortOrder = noteOrderBy == .ascending ? .forward : .reverse
        var predicate: Predicate<Note>?
        if !noteSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            predicate = .init(#Predicate { $0.content.contains(noteSearchText) })
        }
        if noteSortBy == .content {
            return Query(filter: predicate, sort: \.content, order: sortOrder)
        } else {
            return Query(filter: predicate, sort: \.createdAt, order: sortOrder)
        }
    }
    var taglist : some View{
        NavigationStack{
            TagListView(_allTags: tagListQuery)
                .searchable(text: $tagSearchText, prompt: "Search")
                #if os(macOS)
                .textCase(.none)
                #else
                .textInputAutocapitalization(.never)
                #endif
                .navigationTitle("Tags")
                .toolbar {
                    ToolbarItemGroup {
                        Menu {
                            Picker("Order by", selection: $tagOrderBy) {
                                ForEach(OrderBy.allCases) {
                                    Text($0.text).id($0)
                                }
                            }
                        } label: {
                            Label(tagOrderBy.text, systemImage: "arrow.up.arrow.down")
                        }
                    }
                }
        }
        .tabItem{ Label("Tags", systemImage: "tag")}
    }
    var tagListQuery: Query<Tag, [Tag]> {
        let sortOrder: SortOrder = tagOrderBy == .ascending ? .forward : .reverse
        var predicate: Predicate<Tag>?
        if !tagSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            predicate = .init(#Predicate { $0.name.contains(tagSearchText) })
        }
        return Query(filter: predicate, sort: \.name, order: sortOrder)
    }
}
