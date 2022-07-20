//
//  PodcastItemCell.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import UIKit
import Kingfisher

protocol PodcastItemProtocol {
    var imageURL: URL { get }
    var title: String { get }
    var subtitle: String { get }
}

final class PodcastItemCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    class var identifier: String {
        String(describing: PodcastItemCell.self)
    }
    
    class var cellHeight: CGFloat {
        return 50.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.kf.indicatorType = .activity
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
    }
    
    func configure(viewModel: PodcastItemProtocol) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        thumbnailImageView.kf.setImage(with: viewModel.imageURL)
    }
    
}
