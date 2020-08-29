//
//  MenuCell.swift
//  UberEats
//
//  Created by Varun Rathi on 28/08/20.
//

import UIKit

class MenuCell: UITableViewCell {
    
    let staticImageName = "menuitem"
    class var reuseIdentifier:String {
        return String(describing: self)
    }
    
    @IBOutlet  var lblDishName:UILabel!
    @IBOutlet var lblDescription:UILabel!
    @IBOutlet var lblPrice:UILabel!
    @IBOutlet var imgDishView:UIImageView!
  
    func configureWith(_ item: ItemViewModel?){
        lblPrice.text = item?.menuPriceStr
        lblDescription.text = item?.menuDescStr
        lblDishName.text = item?.menuNameStr
        imgDishView.image = UIImage(named: staticImageName)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
