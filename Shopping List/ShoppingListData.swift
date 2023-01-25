//
//  ShoppingListData.swift
//  Shopping List
//
//  Created by Finn Kliewer on 1/24/23.
//

import Foundation

class ShoppingListData {
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
