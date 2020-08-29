//
//  MenuListViewController.swift
//  UberEats
//
//  Created by Varun Rathi on 28/08/20.
//

import UIKit

class MenuListViewController: UIViewController {
   @IBOutlet var tableView:UITableView!
    var segmentedControl:ScrollableSegmentedControl!
   var segmentControl:UISegmentedControl!
   
   
   var viewModel: MenuListViewModel!
   var data:[[MenuItem]] = []
   var sections:[String] = []
    var currentVisibleSection:Int = 0 {
        didSet {
            setSelectedSegmentOnScroll(currentVisibleSection)
        }
    }
    
    
//    init(_ viewModel:MenuListViewModel) {
//        self.viewModel = viewModel
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
        configureUI()
        registerHeader()
    }
    
    func registerHeader(){
        tableView.register(UINib(nibName: "SectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    
    func configureUI(){
        configureTableView()
        configureSegmentedSections()
       // addSegmentedController()
    }
    
    func addSegmentedController() {
    let segmentedControl = ScrollableSegmentedControl(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
    self.segmentedControl = segmentedControl
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Segment 1", image: nil, at: 0)
        segmentedControl.insertSegment(withTitle: "Segment 2", image: nil, at: 1)
        segmentedControl.insertSegment(withTitle: "Segment 3", image: nil, at: 2)
    segmentedControl.insertSegment(withTitle: "Segment 4", image: nil, at: 3)
    segmentedControl.insertSegment(withTitle: "Segment 5", image: nil, at: 4)
    segmentedControl.insertSegment(withTitle: "Segment 6", image: nil, at: 5)
        
    segmentedControl.underlineSelected = true
        
    segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)

    // change some colors
    segmentedControl.segmentContentColor = UIColor.white
    segmentedControl.selectedSegmentContentColor = UIColor.yellow
    segmentedControl.backgroundColor = UIColor.black
    
    // Turn off all segments been fixed/equal width.
    // The width of each segment would be based on the text length and font size.
    segmentedControl.fixedSegmentWidth = false
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(segmentedControl)
    }
    
    
    func configureSegmentedSections(){
        let frame = CGRect(x: 0, y: 0, width: 700, height: 60)
        let sc = MyCustomSegmentControl(frame:frame, titles: ["1","2","3","4","5","6"], cornerRadius: 5.0, foregroundColor: .blue, selectedForegroundColor: .black, selectorColor: .darkGray, bgColor: .cyan)
        
        view.addSubview(sc)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    func fillData() {
        viewModel = MenuListViewModel(RestaurantMenu.getStaticData()!)
       
       
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        scrollTableView(sender.selectedSegmentIndex)
    }
    
    func setSelectedSegmentOnScroll(_ index:Int){
        guard index < data.count else { return }

        segmentedControl.selectedSegmentIndex = index
    }
    
    func scrollTableView(_ section:Int,animated: Bool = true){
        guard section < data.count else { return }
        
        tableView.scrollToRow(at: IndexPath(row:0, section: section), at: .top, animated:animated)
    }
    
    
}




