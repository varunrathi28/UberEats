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
            //    setSelectedSegmentOnScroll(indexPath.section)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("-debug- = \(scrollView.isTracking) \(scrollView.contentOffset)")
        if scrollView == tableView, isManualScroll {
            if let indexpath = tableView.indexPathsForVisibleRows?.first, currentVisibleSection != indexpath.section {
                if lastContentOffset  < scrollView.contentOffset.y {
                    setSelectedSegmentOnScroll(currentVisibleSection + 1)
                    }
                    else if currentVisibleSection > 0{
                    setSelectedSegmentOnScroll(currentVisibleSection - 1)
                    }
                    // move up
            }
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isManualScroll = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isManualScroll = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            isManualScroll = false
    }
    
   
}
