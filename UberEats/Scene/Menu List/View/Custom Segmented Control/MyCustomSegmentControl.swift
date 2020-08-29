//
//  MyCustomSegmentControl.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import UIKit

@IBDesignable
class MyCustomSegmentControl: UIControl {
    
    public var selectedSegmentIndex = 0
    let interItemSpacing:CGFloat = 20
    
    @IBInspectable
    var borderWidth:CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    

     @IBInspectable
     var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable
    var  commaSeparatedTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var textColor:UIColor = .lightGray {
        didSet {
            segments.forEach {
                $0.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .darkGray {
        didSet{
            selectorView.backgroundColor = selectorColor
        }
    }
    
    @IBInspectable
    var selectedTextColor: UIColor = .darkGray {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var selectorCornerRadius: CGFloat = 0.0 {
        didSet {
            selectorView.layer.cornerRadius = selectorCornerRadius
        }
    }
    
    var segments:[UIButton] = []
    
    lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isScrollEnabled = true
        return scroll
    }()
    
     var stackView:UIStackView = UIStackView()
    var selectorView:UIView = UIView()
    
    
     
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init(frame:CGRect,titles: [String] = [], cornerRadius: CGFloat,
                            foregroundColor: UIColor, selectedForegroundColor: UIColor, selectorColor: UIColor, bgColor: UIColor) {
        self.init(frame: frame)
        self.segments = getSegmentButtons(from: titles)
       // self.selectorStyle = selectorStyle
       // self.foregroundColor = fgColor
       // self.selectedForegroundColor = selectedFgColor
        self.selectorColor = selectorColor
        self.backgroundColor = bgColor
        
        updateView()
        defer {
            self.selectorCornerRadius = cornerRadius
        }
    }
    
    public func appendSegment(_ title:String, textColor: UIColor ){
        let segment = createSegmentButton(title: title)
        segments.append(segment)
    }
    
    
    func updateView(){
        
        segments.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        let buttonTitles = commaSeparatedTitles.components(separatedBy:",")
        segments = getSegmentButtons(from: buttonTitles)
        
        for idx in 0..<segments.count {
            segments[idx].backgroundColor = .clear
            segments[idx].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            segments[idx].tag = idx
        }
       
        setUpScrollView()
        setUpStackView()
        //scrollView.contentSize =  CGSize(width: scrollView.frame.width*2, height: scrollView.frame.height)
        
        let selectorWidth = frame.width / CGFloat(segments.count)
        selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
         selectorView.backgroundColor = selectorColor
        addSubview(selectorView)
        
        layoutIfNeeded()
    }
    
    
    func commonInit(){
        setUpScrollView()
        setUpStackView()
    }
    
    
    func getSegmentButtons(from titles:[String]) -> [UIButton]{
        var array = [UIButton]()
           for title in titles {
           let aButton = createSegmentButton(title: title)
            array.append(aButton)
        }
        return array
    }
    
    func createSegmentButton(title:String)->UIButton {
         let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(self.textColor, for: .normal)
            return button
    }

    func setUpStackView(){
        stackView = UIStackView(frame: scrollView.frame)
        
        for item in segments {
            stackView.addSubview(item)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = interItemSpacing
        
        scrollView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
    
    func setUpScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        selectorView.layer.cornerRadius = selectorCornerRadius
    }
    
    open func moveView(_ view: UIView, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil, toX: CGFloat) {
        view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: 0.0)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        view.transform = CGAffineTransform(translationX: toX, y: 0.0)
        }, completion: completion)
    }
    
     @objc func buttonTapped(button: UIButton) {
        for (idx, btn) in segments.enumerated() {
            let image = btn.image(for: .normal)
          
            if btn.tag == button.tag {
                selectedSegmentIndex = idx
            //    moveView(selector, toX: btn.frame.origin.x)
            }
        }
        sendActions(for: .valueChanged)
    }
    

}
