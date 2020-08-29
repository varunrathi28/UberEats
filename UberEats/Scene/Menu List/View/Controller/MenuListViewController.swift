//
//  MenuListViewController.swift
//  UberEats
//
//  Created by Varun Rathi on 28/08/20.
//

import UIKit

class MenuListViewController: UIViewController {
   @IBOutlet var tableView:UITableView!
   @IBOutlet var segmentControl:MyCustomSegmentControl!
   var dynamicSegmentControl:DynamicSegmentControl!
   
   @IBOutlet var scrollView : UIScrollView!
   var isManualScroll:Bool = false
   var viewModel: MenuListViewModel!
   var data:[[MenuItem]] = []
   var sections:[String] = []
    var currentVisibleSection:Int = 0
     var lastContentOffset: CGFloat = 0
    
    
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
        setUpSegmentedControl()
    }
    
    func setUpSegmentedControl(){
        segmentControl.changeSegments(viewModel.sectionTitles())
        segmentControl.selectedTextColor = .white
        segmentControl.clickCompletion = {[weak self] index in
            guard let self = self else {
                return
            }
            self.scrollTableView(index)
        }
    }
    
    /*
    func configureSegmentedSections(){
        let frame = CGRect(x: 0, y: 0, width: 700, height: 60)
        let sc = MyCustomSegmentControl(frame:frame, titles: ["1","2","3","4","5","6"], cornerRadius: 5.0, foregroundColor: .blue, selectedForegroundColor: .black, selectorColor: .darkGray, bgColor: .cyan)
        
        view.addSubview(sc)
    }
    */
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    func fillData() {
        viewModel = MenuListViewModel(RestaurantMenu.getStaticData()!)
    }
    
    
    
    func setSelectedSegmentOnScroll(_ index:Int){
        guard index < viewModel.numberOfSections else { return }
        segmentControl.setSegmentSelected(index: index)
        currentVisibleSection = index

    }
    
    func scrollTableView(_ section:Int,animated: Bool = true){
        guard section < viewModel.numberOfSections else { return }
        
        isManualScroll = false
        currentVisibleSection = section
        tableView.scrollToRow(at: IndexPath(row:0, section: section), at: .top, animated:animated)
    }
    
    
}




