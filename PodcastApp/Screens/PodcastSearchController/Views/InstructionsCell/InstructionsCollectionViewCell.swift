//
//  InstructionsCollectionViewCell.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import UIKit


class InstructionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var largeImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    
    class var identifier: String {
        String(describing: InstructionsCollectionViewCell.self)
    }
    
    class var cellHeight: CGFloat {
        return 383
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }
    
    private func resetUI() {
        largeImageView.image = nil
        titleLabel.text = nil
        instructionsLabel.text = nil
    }
    
    func configure(viewModel: InstructionItemViewModel) {
        largeImageView.image = viewModel.image
        titleLabel.text = viewModel.title
        instructionsLabel.text = viewModel.description
    }

}
