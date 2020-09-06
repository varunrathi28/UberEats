//
//  CustomSegmentedControl.swift
//  UberEats
//
//  Created by Varun Rathi on 06/09/20.
//

import UIKit

@IBDesignable open class CustomSegmentedControl : UIControl, UIGestureRecognizerDelegate {
    public private(set) var selectedSegmentIndex: Int
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialIndicatorViewFrame: CGRect?
    public let indicatorView = IndicatorThumbView()
    private var scrollView =  UIScrollView()
    private let normalSegmentsView = UIView()
    private let selectedSegmentsView = UIView()
    private var width: CGFloat { return bounds.width }
    private var height: CGFloat { return bounds.height }
    private var normalSegmentsCount :Int {
        return normalSegmentsView.subviews.count
    }
    private var segmentInset:CGFloat = 10.0
    
    var segmentOffset:[CGFloat] = []
    
    private var normalSegments: [UIView] {
        return normalSegmentsView.subviews
    }
    
    private var selectedSegments:[UIView] {
        return selectedSegmentsView.subviews
    }
    
    private var segmentViews: [UIView] { return normalSegments + selectedSegments }
    
    private var lastIndex: Int {
        return segments.endIndex - 1
    }
    
    var totalContentWidth:CGFloat
    
    var segments : [CustomMaskSegment] {
        didSet  {
            guard  segments.count > 1 else {
                return
            }
            
            normalSegmentsView.subviews.forEach({ $0.removeFromSuperview() })
            selectedSegmentsView.subviews.forEach({ $0.removeFromSuperview() })
            
            for segment in segments {
                normalSegmentsView.addSubview(segment.normalView)
                selectedSegmentsView.addSubview(segment.selectedView)
            }
            
            setNeedsLayout()
        }
    }
    
     var customizeOptions:[SegmentControlOptions]? {
        get {
            return nil
        }
        set {
            guard let options = newValue else {
                return
            }
            
            for option in options {
                switch option {
                case .cornerRadius(let value):
                    cornerRadius = value
                    
                case .selectorBackgroundColor(let newSelectorColor):
                selectorBackgroundColor = newSelectorColor
                default:
                    print("")
                }
              
            }
            
        }
    }
    
    @IBInspectable public var animationDuration: TimeInterval = 1.0
    @IBInspectable public var animationSpringDamping: CGFloat = 0.75
    @IBInspectable public var announcesValueImmediately: Bool = true
    @IBInspectable public var indicatorViewBorderColor: UIColor? {
        get {
            guard let color = indicatorView.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            indicatorView.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var indicatorViewInset: CGFloat = 2.0 {
        didSet {
            updateCornerRadius()
            setNeedsLayout()
        }
    }
    
     @IBInspectable public var selectorBackgroundColor: UIColor? {
        get {
            return indicatorView.backgroundColor
        }
        set {
            indicatorView.backgroundColor = newValue
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            updateCornerRadius()
        }
    }
    
    public init(frame:CGRect, segments:[CustomMaskSegment],defaultIndex: Int = 0, options:[SegmentControlOptions]? = nil) {
        self.selectedSegmentIndex = defaultIndex
        self.segments = segments
        self.totalContentWidth = .zero
        super.init(frame: frame)
        self.customizeOptions = options
        commonInit()
        
    }
    
    required public init?(coder: NSCoder) {
        self.selectedSegmentIndex = 0
        self.segments = [CustomLabelSegment(title:"Abc")]
        self.totalContentWidth = .zero
        super.init(coder: coder)
        commonInit()
    }
    
    // Setting UP the View Hierarchy
    /****  Order is important
     1. Normal View
     2. Indicator View
     3. Selected View
     */
    func commonInit() {
        layer.masksToBounds = true
        normalSegmentsView.clipsToBounds = true
        selectedSegmentsView.clipsToBounds = true
        
        scrollView = UIScrollView(frame: self.frame)
        addSubview(scrollView)
       
        scrollView.contentSize = CGSize(width: 500, height: 50)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.showsHorizontalScrollIndicator = false
        
        
        let stackView = UIStackView(arrangedSubviews: normalSegments)
        
        scrollView.addSubview(normalSegmentsView)
        scrollView.addSubview(indicatorView)
        scrollView.addSubview(selectedSegmentsView)
        selectedSegmentsView.layer.mask = indicatorView.segmentMaskView.layer
        
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        guard segments.count > 1 else {
            return
        }
        
        segmentOffset = []
        var totalContentSize:CGFloat = 0.0
        for segment in self.segments {
            //Normal View
            segment.normalView.clipsToBounds = true
            normalSegmentsView.addSubview(segment.normalView)
            
            //Selected View
            segment.selectedView.clipsToBounds = true
            selectedSegmentsView.addSubview(segment.selectedView)
            segmentOffset.append(totalContentSize)
            totalContentSize += segment.contentWidth
        }
        
        self.totalContentWidth = totalContentSize
        var contentSize = scrollView.contentSize
        contentSize.width = totalContentSize
        scrollView.contentSize = CGSize(width: 500, height: 50)
        layoutIfNeeded()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard normalSegmentsCount > 1 else {
            return
        }
//        var frame = bounds
//        frame.width = tot

        var frame = bounds
        frame.size.width = scrollView.contentSize.width
        normalSegmentsView.frame = frame
        selectedSegmentsView.frame = frame
        indicatorView.frame = elementFrame(forIndex: selectedSegmentIndex)
        
        for i in 0..<normalSegmentsCount {
            let frame = elementFrame(forIndex: i)
            normalSegmentsView.subviews[i].frame = frame
            selectedSegmentsView.subviews[i].frame = frame
        }
        
    }
    
    public func setIndex(_ newIndex:Int,animation:Bool = true){
        guard 0..<normalSegmentsCount ~= newIndex else {
            return
        }
        
        let oldIndex = self.selectedSegmentIndex
        self.selectedSegmentIndex = newIndex
        moveIndicatorView(animation, shouldSendEvent: oldIndex != newIndex || announcesValueImmediately)
    }
    
    
    private func moveIndicatorView(_ animated: Bool, shouldSendEvent: Bool) {
        if animated{
            if shouldSendEvent && announcesValueImmediately {
                sendActions(for: .valueChanged)
            }
            
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: animationSpringDamping,
                           initialSpringVelocity: 0.0,
                           options: [.beginFromCurrentState, .curveEaseOut],
                           animations: { () -> Void in
                              self.moveIndicatorView()
                           }, completion: { finished -> Void in
                            if finished && shouldSendEvent && !self.announcesValueImmediately {
                                self.sendActions(for: .valueChanged)
                            }
                           })
        }
        else {
            moveIndicatorView()
            
            if shouldSendEvent {
                sendActions(for: .valueChanged)
            }
        }
    }
    
    private func nearestIndex(toPoint point: CGPoint) -> Int {
        let distances = normalSegments.map { abs(point.x - $0.center.x) }
        return Int(distances.firstIndex(of: distances.min()!)!)
    }
    
    private func updateCornerRadius() {
        indicatorView.cornerRadius = cornerRadius - indicatorViewInset
        segmentViews.forEach { $0.layer.cornerRadius = indicatorView.cornerRadius }
    }
    
    func moveIndicatorView(){
        indicatorView.frame = normalSegments[selectedSegmentIndex].frame
        layoutIfNeeded()
    }
    
    @objc private func tapped(_ gestureRecognizer: UITapGestureRecognizer!) {
        let location = gestureRecognizer.location(in: scrollView)
        setIndex(nearestIndex(toPoint: location))
        updateContentOffset()
    }
    
    func updateContentOffset(){
        let selectedSegmentStartX = self.segmentOffset[selectedSegmentIndex]
        var contentOffset = scrollView.contentOffset
        if scrollView.contentSize.width - scrollView.frame.size.width > selectedSegmentStartX {
            contentOffset.x = selectedSegmentStartX
            DispatchQueue.main.async {
                self.scrollView.setContentOffset(contentOffset, animated: true)
            }
        }
       
    }
    
    @objc private func panned(_ gestureRecognizer: UIPanGestureRecognizer!) {
        switch gestureRecognizer.state {
        case .began:
            initialIndicatorViewFrame = indicatorView.frame
        case .changed:
            var frame = initialIndicatorViewFrame!
            frame.origin.x += gestureRecognizer.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - indicatorViewInset - frame.width), indicatorViewInset)
            indicatorView.frame = frame
        case .ended, .failed, .cancelled:
            setIndex(nearestIndex(toPoint: indicatorView.center))
        default: break
        }
    }
    
    //MARK:- Helpers
    private func elementFrame(forIndex index: Int) -> CGRect {
        let elementWidth = self.segments[index].contentWidth + segmentInset
        var totalOffset:CGFloat = 0
        for i in 0..<index {
            totalOffset += self.segments[i].contentWidth
        }
        let x = totalOffset
        return CGRect(x: x, y: indicatorViewInset, width: elementWidth, height: height)
    }
    
}

