//
//  PodcastsCollectionViewController.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import UIKit
import Moya
import RxSwift


final class PodcastsCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    private lazy var dataSource = makeDataSource()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<PodcastSection, PodcastSectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PodcastSection, PodcastSectionItem>
    
    private var disposeBag = DisposeBag()
    
    private let viewModel: PodcastCollectionViewModelProtocol
    private var coordinator: MainCoordinator?
    
    init(viewModel: PodcastCollectionViewModelProtocol, coordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(viewModel:)")
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        registerCells()
        configureSearchController()
        bindData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: - Methods
private extension PodcastsCollectionViewController {
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView,
                                    cellProvider: { (collectionView, indexPath, podcastsCollectionItem) -> UICollectionViewCell? in
            
            func configureInstructionsCell(viewModel:  InstructionItemViewModel) -> UICollectionViewCell? {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstructionsCollectionViewCell.identifier,
                                                              for: indexPath) as! InstructionsCollectionViewCell
                cell.configure(viewModel: viewModel)
                return cell
            }
            
            switch podcastsCollectionItem {
            case .startSearch(let instruction):
                let cell = configureInstructionsCell(viewModel: instruction)
                return cell
            case .podcast(let podcast):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastItemCell.identifier,
                                                              for: indexPath) as! PodcastItemCell
                cell.configure(viewModel: podcast)
                return cell
            case .error(let errorInstructions):
                let cell = configureInstructionsCell(viewModel: errorInstructions)
                return cell
            case .empty(let noDataInstructions):
                let cell = configureInstructionsCell(viewModel: noDataInstructions)
                return cell
            case .loading(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier,
                                                              for: indexPath) as! EmptyCollectionViewCell
                return cell
            }
        })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let podcastsCollectionSection = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: PodcastHeaderView.identifier, for: indexPath) as! PodcastHeaderView
            if case let .podcasts(sectionTitle) = podcastsCollectionSection {
                view.configure(title: sectionTitle ?? "")
            }
            return view
        }
        return dataSource
    }
    
    func applySnapshot(sections: [PodcastSectionViewModel], animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        sections.forEach { podcastSectionViewModel in
            snapshot.appendSections([podcastSectionViewModel.section])
            snapshot.appendItems(podcastSectionViewModel.podcastSectionItems)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

// MARK: - Layout Handling
private extension PodcastsCollectionViewController {
    
    func bindData() {
        viewModel.data.subscribe(onNext: { [weak self] sections in
            self?.configureLayout()
            self?.applySnapshot(sections: sections)
        })
        .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let value = strongSelf.searchController.searchBar.text
                strongSelf.viewModel.querryString.onNext(value)
            })
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        title = "Podcasts"
        collectionView.backgroundColor = UIColor.init(red: 29.0/255.0, green: 30.0/255.0, blue: 31.0/255.0, alpha: 1.0)
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search podcast"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchBarStyle = .prominent
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func registerCells() {
        let podcastHeaderNib = UINib(nibName: PodcastHeaderView.identifier, bundle: nil)
        collectionView.register(podcastHeaderNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PodcastHeaderView.identifier)
        
        let emptyCellNib = UINib(nibName: EmptyCollectionViewCell.identifier, bundle: nil)
        collectionView.register(emptyCellNib,
                                forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier)
        
        let podcastCellNib = UINib(nibName: PodcastItemCell.identifier, bundle: nil)
        collectionView.register(podcastCellNib,
                                forCellWithReuseIdentifier: PodcastItemCell.identifier)
        
        let instructionsCellNib = UINib(nibName: InstructionsCollectionViewCell.identifier, bundle: nil)
        collectionView.register(instructionsCellNib,
                                forCellWithReuseIdentifier: InstructionsCollectionViewCell.identifier)
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let size = self.itemLayout(sectionIndex: sectionIndex)
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            section.interGroupSpacing = 8
            section.supplementariesFollowContentInsets = false
            if self.viewModel.hasData {
                let headerFooterSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(PodcastHeaderView.cellHeight)
                )
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        })
    }
    
    func itemLayout(sectionIndex: Int) -> NSCollectionLayoutSize {
        let cellType = viewModel.data.value.first!.podcastSectionItems.first!
        var height = 0.0
        switch cellType {
        case .startSearch(_):
            height = InstructionsCollectionViewCell.cellHeight
        case .podcast(_):
            height = PodcastItemCell.cellHeight
        case .error(_):
            height = InstructionsCollectionViewCell.cellHeight
        case .empty(_):
            height = InstructionsCollectionViewCell.cellHeight
        case .loading(_):
            height = PodcastItemCell.cellHeight
        }
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(height)
            )
    }
    
}

// MARK: - UICollectionViewDataSource Implementation
extension PodcastsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard let itemSelected = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        guard case PodcastSectionItem.podcast(let podcastItem) = itemSelected else {
            return
        }
        coordinator?.showPodcastDetails(podcasst: podcastItem.podcast)
    }
}
