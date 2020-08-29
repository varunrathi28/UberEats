//
//  MenuList+TableView.swift
//  UberEats
//
//  Created by Varun Rathi on 29/08/20.
//

import UIKit

extension MenuListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MenuListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let  headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as! SectionHeaderView
            headerView.setTitle(viewModel.sectionNameFor(section))
            return headerView
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseIdentifier, for: indexPath) as! MenuCell
        let cellViewModel = viewModel.cellVieWModel(for: indexPath)
        cell.configureWith(cellViewModel)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("end \(indexPath)")
         if indexPath.section != currentVisibleSection {
          //  currentVisibleSection = indexPath.section
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView == tableView {
               if let indexpath = tableView.indexPathsForVisibleRows?.first, indexpath.row == 0 {
                    setSelectedSegmentOnScroll(indexpath.section)
               }
            }
    }
    
   
}
