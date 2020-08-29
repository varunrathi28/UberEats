//
//  MenuCellViewModel.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import Foundation

struct MenuCellViewModel : ItemViewModel {
    private let menu: MenuItem
    
    init(menu: MenuItem) {
        self.menu = menu
    }
    
    var menuNameStr:String {
        return menu.dishName
    }
    
    var menuDescStr:String {
        return menu.description
    }
    
    var menuPriceStr : String {
        return menu.priceText
    }
}
