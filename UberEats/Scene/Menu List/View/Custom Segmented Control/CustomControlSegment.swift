//
//  CustomControlSegment.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import UIKit

public protocol CustomSegmentedControlSegment{
    var normalView : UIView {  get  }
    var selectedView: UIView { get }
}
