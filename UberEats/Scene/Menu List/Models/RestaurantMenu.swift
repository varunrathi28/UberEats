//
//  MenuSection.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import Foundation

struct MenuSection : Codable{
        var sectionName:String
        var items:[MenuItem]
}
    
public class RestaurantMenu : Codable{
    var menus:[MenuSection]
    
    init(_ data:[String:Any]) {
        menus = []
    }
    
    func menuItem(at indexPath:IndexPath) -> MenuItem?{
        guard indexPath.section < menus.count, indexPath.row < menus[indexPath.section].items.count else {
            return nil
        }
        return menus[indexPath.section].items[indexPath.row]
    }

    class func getStaticData()-> RestaurantMenu?{
         let path = Bundle.main.path(forResource: "data", ofType: "json")!
        var result: RestaurantMenu?
         
    do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
          let jsonDecoder = JSONDecoder()
        result = try jsonDecoder.decode(RestaurantMenu.self, from: data)
         
      } catch let error {
        print("Parsing Failed \(error.localizedDescription)")
           // handle error
           
      }
      return result
        
    }
}
