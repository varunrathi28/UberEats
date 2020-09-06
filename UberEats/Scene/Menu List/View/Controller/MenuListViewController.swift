//
//  MenuListViewController.swift
//  UberEats
//
//  Created by Varun Rathi on 28/08/20.
//

import UIKit

class MenuListViewController: UIViewController {
    @IBOutlet var tableView:UITableView!
    var segmentView:CustomSegmentedControl!
    @IBOutlet var segmentContainerView:UIView!
    var isManualScroll:Bool = false
    var viewModel: MenuListViewModel!
    var data:[[MenuItem]] = []
    var sections:[String] = []
    var currentVisibleSection:Int = 0
    var lastContentOffset: CGFloat = 0
    var selectedView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
        return view
    }()
    
    
    //    init(_ viewModel:MenuListViewModel) {
    //        self.viewModel = viewModel
    //    }
    //
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
        segmentView = CustomSegmentedControl(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50), segments: CustomLabelSegment.getSegments(with:viewModel.sectionTitles(), textColor: .black, backgroundColor: .white, selectedTextColor: UIColor.white, selectedBackgroundColor: .black, font: UIFont.systemFont(ofSize: 16)), defaultIndex: 0,options: [.selectorBackgroundColor(UIColor.white),.cornerRadius(25.0)])
        segmentContainerView.addSubview(segmentView)
        segmentView.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
    }
    
    @objc func indexChanged(_ sender: CustomSegmentedControl) {
        guard currentVisibleSection != sender.selectedSegmentIndex else {
            return
        }
       scrollTableView(sender.selectedSegmentIndex)
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
    
    func setSelectedSegmentOnScroll(_ index:Int){
        guard index < viewModel.numberOfSections else { return }
        segmentView.setSegmentSelected(newIndex: index)
        currentVisibleSection = index
    }
    
    func scrollTableView(_ section:Int,animated: Bool = true){
        guard section < viewModel.numberOfSections else { return }
        
        isManualScroll = false
        currentVisibleSection = section
        tableView.scrollToRow(at: IndexPath(row:0, section: section), at: .top, animated:animated)
    }
    
    
}




