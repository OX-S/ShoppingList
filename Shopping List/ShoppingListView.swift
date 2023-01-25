//
//  ShoppingListView.swift
//  Shopping List
//
//  Created by Finn Kliewer on 12/25/22.
//
import Foundation
import SwiftUI

struct ShoppingList: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var items: [String]
    @State private var purchasedItems: Set<String>
    
    init() {
        self._items = State(initialValue: Self.loadItems())
        self._purchasedItems = State(initialValue: Self.loadPurchasedItems())
    }

    var body: some View {
        VStack {
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        Button(action: {
                            self.purchasedItems.insert(item)
                            Self.savePurchasedItems(self.purchasedItems)
                        }) {
                            if self.purchasedItems.contains(item) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            
            HStack {
                TextField("Add Item", text: $newItem)
                Button(action: {
                    self.items.append(self.newItem)
                    Self.saveItems(self.items)
                    self.newItem = ""
                }) {
                    Image(systemName: "plus")
                }
            }
            .padding()
            
            Button(action: {
                self.items.removeAll(where: { self.purchasedItems.contains($0) })
                self.purchasedItems.removeAll()
                Self.saveItems(self.items)
                Self.savePurchasedItems(self.purchasedItems)
            }) {
                Text("Clear Purchased Items")
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        Self.saveItems(self.items)
    }
    
    @State private var newItem = ""
    
    static func saveItems(_ items: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(items, forKey: "items")
    }
    
    static func loadItems() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.stringArray(forKey: "items") ?? []
    }
    
    static func savePurchasedItems(_ items: Set<String>) {
        let defaults = UserDefaults.standard
        defaults.set(Array(items), forKey: "purchasedItems")
    }
    
    static func loadPurchasedItems() -> Set<String> {
        let defaults = UserDefaults.standard
        return Set(defaults.stringArray(forKey: "purchasedItems") ?? [])
    }
}
