//
//  MenuList+CollectionView.swift
//  UberEats
//
//  Created by Varun Rathi on 01/09/20.
//

import UIKit


extension MenuListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSections
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.reuseIdentifier, for: indexPath) as! CustomCollectionCell
        cell.configureWith(viewModel.sectionNameFor(indexPath.row))
        return cell
    }
    
}

extension MenuListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    scrollTableView(indexPath.row, animated: true)
    moveSelectedView(to: indexPath.row)
}

}


extension MenuListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CustomCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.reuseIdentifier, for: indexPath) as? CustomCollectionCell else {
            return CGSize.zero
        }
        cell.configureWith(viewModel.sectionNameFor(indexPath.row))
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
}


extension MenuListViewController {


    func moveSelectedView(to index:Int){
  
   if   let theAttributes = collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0)){
           
              UIView.animate(withDuration: 0.3) {
                self.selectedView.frame = theAttributes.frame
               
                self.selectedView.layer.cornerRadius = theAttributes.frame.height/2
              //  self.selectedView.center = theAttributes.center
        }
            
        }
   
    }

    
}
