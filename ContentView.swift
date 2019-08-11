//
//  ContentView.swift
//  swiftui-demo-temp
//
//  Created by Anton Sokolov on 11.08.2019.
//  Copyright © 2019 Anton Sokolov. All rights reserved.
//

import SwiftUI
import Combine

struct Item: Identifiable, Comparable {
    var id: Int
    var name:String
    
    static func < (lhs: Item, rhs: Item) -> Bool {
        return lhs.name < rhs.name
    }
}

class ItemStore : ObservableObject {
    let didChange = PassthroughSubject<ItemStore, Never>()
    var items : [Item] {
        didSet { didChange.send(self) }
    }
    
    init (items: [Item] = []){
        self.items = items
    }
}

struct ContentView : View {
    @ObservedObject  var store = ItemStore(items: items.sorted())
    var body: some View {
        NavigationView {
            List {
                ForEach(store.items) { item in
                    ItemView(item: item)
                }.onDelete(perform: delete)
            }
            .navigationBarTitle(Text("My Stuff"))
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            store.items.remove(at: first)
        }
    }
}

struct ItemView: View {
    var item: Item

    var body: some View {
        Text("\(item.name)")
    }
}

#if DEBUG
var items = [
    Item(id: 0, name: "Wardrobe"),
    Item(id: 1, name: "Table"),
    Item(id: 2, name: "Dresser"),
    Item(id: 3, name: "Sideboard"),
    Item(id: 3, name: "Bookcase")
]

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(store: ItemStore(items:items.sorted()))
    }
}
#endif
