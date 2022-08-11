//
//  MainTableViewCell.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    // contentCollectionView도 delegate, dataSource 필요함
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        print(MainTableViewCell.reuseIdentifier, #function)
    }

    func setupUI() {
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "넷플릭스 인기 컨텐츠"
        titleLabel.backgroundColor = .clear
        
        contentCollectionView.backgroundColor = .lightGray
        contentCollectionView.collectionViewLayout = collectionViewLayout()
        
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }
    
}
