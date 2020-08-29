//
//  MenuListViewModel.swift
//  UberEats
//
//  Created by Varun Rathi on 28/08/20.
//

import Foundation

protocol RestaurantMenuViewModel:class {
}

class MenuListViewModel : RestaurantMenuViewModel {
    private var menuData:RestaurantMenu
    
     init(_ menuData:RestaurantMenu){
        self.menuData = menuData
    }
    
    var numberOfSections:Int {
        return menuData.menus.count
    }
    
    func numberOfRows(section:Int) -> Int {
        return menuData.menus[section].items.count
    }
    
    func cellVieWModel(for indexPath:IndexPath)-> MenuCellViewModel? {
        if let menuItem = menuData.menuItem(at: indexPath) {
            return MenuCellViewModel(menu: menuItem)
        }
        return nil
    }
    
    func sectionNameFor(_ section:Int) -> String {
        return menuData.menus[section].sectionName
    }
    
    func sectionTitles() -> [String]{
        let titles = menuData.menus.map {
            $0.sectionName
        }
        return titles
    }
    
    
}
