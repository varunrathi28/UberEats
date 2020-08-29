//
//  MenuCellViewModel.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import Foundation

struct MenuCellViewModel : ItemViewModel {
    private let menu: Menu
    var menuNameStr:String {
        return menu.menuName
    }
    
    var menuDescStr:String {
        return menu.menuDesc ?? ""
    }
    
    var menuPriceStr : String {
        return menu.menuPrice ?? ""
    }
}
