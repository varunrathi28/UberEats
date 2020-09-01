//
//  CustomCollectionCell.swift
//  UberEats
//
//  Created by Varun Rathi on 01/09/20.
//

import UIKit

class CustomCollectionCell: UICollectionViewCell {
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblSelectedTitle:UILabel!
    func configureWith(_ text:String){
        lblTitle.text = text
        lblSelectedTitle.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        lblTitle.textColor = .black
        lblSelectedTitle.textColor = .white
        
        
    }
    
    func setSelected(){
        lblTitle.textColor = .black
        contentView.backgroundColor = .white
        
    }
    
    override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.cornerRadius = frame.height/2 
}
}
