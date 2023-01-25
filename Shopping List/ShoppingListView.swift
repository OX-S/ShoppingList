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
    @State private var showingAlert: Bool = false
    
    
    init() {
        self._items = State(initialValue: ShoppingListData.loadItems())
        self._purchasedItems = State(initialValue: ShoppingListData.loadPurchasedItems())
    }

    var body: some View {
        VStack {
            HStack {
                
                TextField("Add Item", text: $newItem, onCommit: {
                    self.items.append(self.newItem)
                    ShoppingListData.saveItems(self.items)
                    self.newItem = ""
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(10)

                
                
                Button(action: {
                    self.items.append(self.newItem)
                    ShoppingListData.saveItems(self.items)
                    self.newItem = ""
                }) {
                    Image(systemName: "plus")
                }
            }
            .padding()
            
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        Button(action: {
                            self.purchasedItems.insert(item)
                            ShoppingListData.savePurchasedItems(self.purchasedItems)
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
            if !purchasedItems.isEmpty {
                Button(action: {
                    self.items.removeAll(where: { self.purchasedItems.contains($0) })
                    self.purchasedItems.removeAll()
                    ShoppingListData.saveItems(self.items)
                    ShoppingListData.savePurchasedItems(self.purchasedItems)
                }) {
                    Text("Clear Purchased Items")
                }
            } else {
                Button(action: {
                    self.showingAlert = true
                }) {
                    Text("Clear List")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Clear List"), message: Text("Are you sure you want to clear the list?"), primaryButton: .destructive(Text("Yes")) {
                        self.items.removeAll()
                        self.purchasedItems.removeAll()
                        ShoppingListData.saveItems(self.items)
                        ShoppingListData.savePurchasedItems(self.purchasedItems)
                    }, secondaryButton: .cancel())
                }
            }
        }
    }
    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        ShoppingListData.saveItems(self.items)
    }
    @State private var newItem = ""
}
