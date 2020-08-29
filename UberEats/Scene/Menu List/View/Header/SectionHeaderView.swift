//
//  SectionHeaderView.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import UIKit

public class SectionHeaderView: UITableViewHeaderFooterView {
    class var reuseIdentifier:String {
        return String(describing: self)
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(_ title:String) {
        titleLabel.text = title
    }
    
    public override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
