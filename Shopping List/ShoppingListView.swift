//
//  ShoppingListView.swift
//  Shopping List
//
//  Created by Finn Kliewer on 12/25/22.
//
import Foundation
import SwiftUI
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ShoppingList: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var items: [String]
    @State private var purchasedItems: Set<String>
    @State private var showingAlert: Bool = false
    @State private var showingDuplicateAlert: Bool = false

    
    
    init() {
        self._items = State(initialValue: ShoppingListData.loadItems())
        self._purchasedItems = State(initialValue: ShoppingListData.loadPurchasedItems())
    }

    var body: some View {
        VStack {
            
            HStack {
                Spacer()

                Text("List").font(.system(size: 28)).padding(.bottom, -4.0).padding(.trailing, -30.0)
                Spacer()
                Button(action: {
                    let itemsString = self.items.joined(separator: "\n")
                    let finalString = "List:\n\n" + itemsString
                    let activityController = UIActivityViewController(activityItems: [finalString], applicationActivities: nil)
                    UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows.first?.rootViewController?.present(activityController, animated: true)
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .padding(.trailing, 10.0)
                   }
            
            HStack {
                
                TextField("Add Item", text: $newItem, onCommit: {
                    if self.newItem.isEmpty {
                        return
                    } else if self.items.contains(self.newItem) {
                        self.showingDuplicateAlert = true

                    } else {
                        self.items.append(self.newItem)
                        ShoppingListData.saveItems(self.items)
                        self.newItem = ""
                    }
                    UIApplication.shared.endEditing()
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(10)

                Button(action: {
                    if self.newItem.isEmpty {
                        return
                    } else if self.items.contains(self.newItem) {
                        self.showingDuplicateAlert = true

                    } else {
                        self.items.append(self.newItem)
                        ShoppingListData.saveItems(self.items)
                        self.newItem = ""
                    }
                }) {
                    Image(systemName: "plus")
                }
                .alert(isPresented: $showingDuplicateAlert) {
                    Alert(title: Text("Item already in list"), message: Text("\"\(self.newItem)\" is already in your list."), dismissButton: .default(Text("OK")))
                }

            }
            .padding()
            
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
 
                        Button(action: {
                            if self.purchasedItems.contains(item) {
                                self.purchasedItems.remove(item)
                            } else {
                                self.purchasedItems.insert(item)
                            }
                            ShoppingListData.savePurchasedItems(self.purchasedItems)
                        }) {
                            if self.purchasedItems.contains(item) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            if !purchasedItems.isEmpty {
                
                Button(action: {
                    self.items = self.items.filter { !self.purchasedItems.contains($0) }
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
            Spacer()
        }
    }
    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        ShoppingListData.saveItems(self.items)
    }
    @State private var newItem = ""
    
    
    
}


