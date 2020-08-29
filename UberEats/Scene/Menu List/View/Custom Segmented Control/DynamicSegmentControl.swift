//
//  DynamicSegmentControl.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import UIKit

public class DynamicSegmentControl: UISegmentedControl {

    var selectedTintColor = UIColor(red: 19/255, green: 59/255, blue: 85/255, alpha: 0.5)
    var themeBackgroundColor = UIColor.init(red: 52/255, green: 59/255, blue: 85/2551, alpha: 1.0)
    var sortedViews:[UIView]!
    var currentIndex:Int =  0
    var arrTabs:[String] = []
    var totalSegments:Int = 0
    @objc var segmentClicked:(Int) -> (Void) = { _ in
    }
    
    var selectedColor:UIColor = UIColor.white
    var unSelectedColor:UIColor = UIColor.lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func addSegments(_ segments:[String]) {
            arrTabs.append(contentsOf: segments)
    
        for s in segments {
            self.insertSegment(withTitle:  s as String, at: totalSegments, animated: false)
            totalSegments += 1
        }
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
     func addSegment(_ segment:String, at index:Int) {

        guard 0...arrTabs.count-1 ~= index else {
            return
        }
    
        if arrTabs.count == 0 {
            arrTabs.append(segment)
        }
        else {
            arrTabs.insert(segment, at: index)
        }
    
    }
    
    func configure() {
        sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        currentIndex = self.selectedSegmentIndex
    
    }
    
    
    @objc func setSegmentSelected(with title:String, callBack: ()->()){
    
        guard let index = arrTabs.firstIndex(of: title) else {
            return
        }
    
        self.selectedSegmentIndex = index
         currentIndex = index
        callBack()
    }
    
    @objc func segmentIndexClicked(sender:UISegmentedControl) {
        let index = selectedSegmentIndex
        currentIndex = index
        segmentClicked(index)
    }
    
     func changeSegment(title:NSString,segment tab:String){
        guard let index = arrTabs.firstIndex(of: tab) else {
            return
        }
        self.setTitle(title as String, forSegmentAt: index)
    }
    
    @objc func getCurrentSelectedTab()->NSString {
         if self.selectedSegmentIndex >= 0 && self.selectedSegmentIndex < self.arrTabs.count {
             return NSString(string: arrTabs[self.selectedSegmentIndex])
         }
         return ""
     }
     
    func changeSelectedIndex(to newIndex: Int) {
        sortedViews[currentIndex].backgroundColor = UIColor.clear
        currentIndex = newIndex
        self.selectedSegmentIndex = UISegmentedControl.noSegment
        sortedViews[currentIndex].backgroundColor = selectedTintColor
    }

    func commonInit(){
    
       self.translatesAutoresizingMaskIntoConstraints = false
       
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor  = selectedTintColor
        } else {
            self.tintColor = selectedTintColor
        }
       self.backgroundColor = UIColor.clear
       
       let selectedAttributes = [NSAttributedString.Key.foregroundColor : selectedColor]
       let unSelectedAttributes  = [NSAttributedString.Key.foregroundColor : unSelectedColor]
       
       self.setTitleTextAttributes(selectedAttributes, for: .selected)
       self.setTitleTextAttributes(unSelectedAttributes, for: .normal)
        self.addTarget(self, action: #selector(segmentIndexClicked(sender:)), for: .valueChanged)
        configure()
    }
    
}
