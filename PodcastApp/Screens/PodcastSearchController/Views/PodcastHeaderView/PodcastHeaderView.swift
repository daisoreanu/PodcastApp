//
//  PodcastCollectionReusableView.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import UIKit


class PodcastHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    class var identifier: String {
        String.init(describing: PodcastHeaderView.self)
    }
    
    class var cellHeight: CGFloat {
        32.0
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func resetUI() {
        
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}

