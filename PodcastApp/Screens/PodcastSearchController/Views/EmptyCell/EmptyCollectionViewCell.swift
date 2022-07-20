//
//  EmptyCollectionViewCell.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {

    class var identifier: String {
        String(describing: EmptyCollectionViewCell.self)
    }
    
    class var cellHeight: CGFloat {
        return 50.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
