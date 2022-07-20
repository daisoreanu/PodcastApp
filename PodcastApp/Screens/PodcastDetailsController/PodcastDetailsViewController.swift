//
//  PodcastDetailsViewController.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 20.07.2022.
//

import UIKit
import RxSwift
import Kingfisher

class PodcastDetailsViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var trackLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    
    private let viewModel: PodcastDetailsProtocol
    private let coordinator: PodcastCoordinator
    
    private let disposeBag = DisposeBag()
    
    public init(viewModel: PodcastDetailsProtocol, coordinator: PodcastCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "Unsuported method, use DI constructor.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("View controller created from a storyboard is unsupported in favor of dependency injection.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureUI()
    }
    
    private func configureUI() {
        imageView.kf.indicatorType = .activity
        let cancelBtn = UIBarButtonItem(title: "Cancel",
                                     style: .plain,
                                     target: self,
                                     action: #selector(userTappedCloseBtn))
        cancelBtn.tintColor = .white
        self.navigationItem.rightBarButtonItems = [cancelBtn]
    }
    
    private func bindData() {
        viewModel.imagePath
            .subscribe(onNext: { [weak self] path in
                self?.imageView.kf.setImage(with: URL(string: path!)!)
            })
            .disposed(by: disposeBag)
        
        viewModel.artistName
            .bind(to: artistLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.trackName
            .bind(to: trackLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.releaseDate
            .bind(to: releaseLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc func userTappedCloseBtn() {
        coordinator.dismissScreensStack()
    }

}
