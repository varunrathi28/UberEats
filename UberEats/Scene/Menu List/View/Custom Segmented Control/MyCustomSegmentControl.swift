//
//  MyCustomSegmentControl.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import UIKit

@IBDesignable
class MyCustomSegmentControl: UIView {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public var selectedSegmentIndex = 0 {
        didSet{
            updateSelector()
        }
    }
    let interItemSpacing:CGFloat = 20
    let padding:CGFloat = 10.0
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
            updateColors()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .darkGray {
        didSet{
            updateColors()
        }
    }
    
    @IBInspectable
    var selectedTextColor: UIColor = .white {
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
    
    @IBInspectable
    var cornerRadius: CGFloat  = 0.0 {
        didSet{
            
        }
        
    }
    
    var segments:[UIButton] = []
    var clickCompletion:((Int) -> ())?
    
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
        self.selectorColor = selectorColor
        self.backgroundColor = bgColor
        updateView()
        defer {
            self.selectorCornerRadius = cornerRadius
        }
    }
    
    func changeSegments(_ titles: [String]){
        self.commaSeparatedTitles = titles.joined(separator:",")
        updateView()
    }
    
    public func appendSegment(_ title:String, textColor: UIColor ){
        let segment = createSegmentButton(title: title)
        segments.append(segment)
      //  updateView()
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
        
        setUpSelectorView()
        setUpScrollView()
        setUpStackView()
        //scrollView.contentSize =  CGSize(width: scrollView.frame.width*2, height: scrollView.frame.height)
    
        updateColors()
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
            button.contentHorizontalAlignment = .center
            return button
    }

    
    func setUpSelectorView(){
        let selectorWidth = frame.width / CGFloat(segments.count)
        selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth - 10, height: frame.height))
        selectorView.backgroundColor = selectorColor
        addSubview(selectorView)
    }

    func setUpStackView(){
        stackView = UIStackView(arrangedSubviews: segments)
        
        for item in segments {
            stackView.addSubview(item)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = interItemSpacing
        scrollView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo:scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.heightAnchor.constraint(equalTo:scrollView.heightAnchor).isActive = true
    }
    
    func setUpScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        selectorView.layer.cornerRadius = frame.height/2
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
        
        selectedSegmentIndex = button.tag
        updateSelector()
        clickCompletion?(selectedSegmentIndex)
        updateColors()
    }
    
    func updateSelector(){
        guard selectedSegmentIndex < segments.count else  { return }
        let newViewToOverlap = segments[selectedSegmentIndex]
        let newCenter = newViewToOverlap.center.x
        let newWidth = newViewToOverlap.frame.width + 2 * padding
        let newSelectorSize = CGSize(width: newWidth, height: selectorView.frame.height)
        
       // moveView(selectorView, toX: newOrigin.x)
        UIView.animate(withDuration: 0.3) {
            self.selectorView.frame.size = newSelectorSize
            self.selectorView.center.x = newCenter
        }
        updateColors()
    }
    
    func setSegmentSelected(index:Int){
        guard  index < segments.count else {
            return
        }
        updateScrollOffetIfNeed(for: index)
        selectedSegmentIndex = index
    }
    
    func updateScrollOffetIfNeed(for section:Int){
        let origin = segments[section].frame.origin.x
        if origin > scrollView.contentOffset.x {
            DispatchQueue.main.async {
                let point = CGPoint(x: origin - self.scrollView.contentOffset.x, y: 0)
                self.scrollView.setContentOffset(point, animated: true)
            }
        }
    }
    
    func updateColors() {
        for (index, button) in segments.enumerated() {
            if index == selectedSegmentIndex {
                button.setTitleColor(selectedTextColor, for: .normal)
            }
            else {
                 button.setTitleColor(textColor, for: .normal)
            }
        }
        
        selectorView.backgroundColor = selectorColor
    }
    

}
