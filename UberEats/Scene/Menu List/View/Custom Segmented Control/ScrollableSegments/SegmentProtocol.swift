//
//  SegmentProtocol.swift
//  UberEats
//
//  Created by Varun Rathi on 06/09/20.
//

import UIKit

public protocol CustomMaskSegment {
    var normalView: UIView { get }
    var selectedView: UIView{ get }
    var contentWidth:CGFloat { get}
}

