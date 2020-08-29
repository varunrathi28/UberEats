//
//  MenuListViewModel.swift
//  UberEats
//
//  Created by Varun Rathi on 28/08/20.
//

import Foundation

 public struct Menu {
       let menuName:String
       let menuDesc:String?
       let menuPrice:String?
}
    
public class RestaurantMenu {
    struct MenuSection {
        var menuName:String
        var items:[Menu]
    }
    
   
    var menus:[MenuSection]
    
    init(_ data:[String:Any]) {
        menus = []
    }
}




enum MenuListActions {
    
}


protocol RestaurantMenuViewModel:class {
}


class MenuListViewModel : RestaurantMenuViewModel {
    private var menuData:RestaurantMenu
    var numberOfSections:Int {
        return menuData.menus.count
    }
    
    init(_ menuData:RestaurantMenu){
        self.menuData = menuData
    }
    
}
