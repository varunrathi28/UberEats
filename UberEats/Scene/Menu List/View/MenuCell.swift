//
//  MenuCell.swift
//  UberEats
//
//  Created by Varun Rathi on 28/08/20.
//

import UIKit

struct MenuItem {
    var dishName:String
    var description:String
    var priceText:String
}

class MenuCell: UITableViewCell {
    
    class var reuseIdentifier:String {
        return String(describing: self)
    }
    
    @IBOutlet  var lblDishName:UILabel!
    @IBOutlet var lblDescription:UILabel!
    @IBOutlet var lblPrice:UILabel!
    @IBOutlet var imgDishView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(_ item: ItemViewModel){
        lblPrice.text = item.menuPriceStr
        lblDescription.text = item.menuDescStr
        lblDishName.text = item.menuNameStr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
