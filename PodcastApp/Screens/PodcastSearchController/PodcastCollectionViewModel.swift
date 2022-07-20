//
//  PodcastCollectionViewModel.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 20.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol PodcastCollectionViewModelProtocol {
    var querryString: PublishSubject<String?> { get }
    var data: BehaviorRelay<[PodcastSectionViewModel]> { get }
    var hasData: Bool { get }
}

class PodcastCollectionViewModel {
    
    var querryString = PublishSubject<String?>()
    lazy var data = BehaviorRelay(value: [startSearchingSection])
    
    private let repository: PodcastRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    private var errorSection: PodcastSectionViewModel = {
        PodcastSectionViewModel(section: PodcastSection.podcasts(),
                                podcastSectionItems: [PodcastSectionItem.error()])
    }()
    
    private var startSearchingSection: PodcastSectionViewModel = {
        PodcastSectionViewModel(section: PodcastSection.podcasts(),
                                podcastSectionItems: [PodcastSectionItem.startSearch()])
    }()
    
    private var emptySection: PodcastSectionViewModel = {
        PodcastSectionViewModel(section: PodcastSection.podcasts(),
                                podcastSectionItems: [PodcastSectionItem.empty()])
    }()
    
    private var loadingSection: PodcastSectionViewModel = {
        PodcastSectionViewModel(section: PodcastSection.podcasts(),
                                podcastSectionItems: PodcastSectionItem.loadingItemsViewModel)
    }()
    
    init(repository: PodcastRepositoryProtocol) {
        self.repository = repository
        bindData()
    }
    
}
 
extension PodcastCollectionViewModel: PodcastCollectionViewModelProtocol {
    #warning("I don't like it, I access first! two time.")
    var hasData: Bool {
        if case PodcastSectionItem.podcast( _) = data.value.first!.podcastSectionItems.first! {
            return true
        }
        return false
    }
}

private extension PodcastCollectionViewModel {
    func podcastSections(_ podcasts: [Podcast]) -> [PodcastSectionViewModel] {
        let groupedPodcasts = Dictionary(grouping: podcasts, by: \.artistName)
        var returendSections = [PodcastSectionViewModel]()
        for (sectionTitle, podcasts) in groupedPodcasts {
            let section = PodcastSection.podcasts(sectionTitle)
            var sectionItems = [PodcastSectionItem]()
            for podcast in podcasts {
                let podcastVM =  PodcastItemViewModel(podcast: podcast)
                sectionItems.append(.podcast(podcastVM))
            }
            returendSections.append(PodcastSectionViewModel(section: section, podcastSectionItems: sectionItems))
        }
        return returendSections
    }
    
    private func bindData() {
        querryString.subscribe(onNext: { [weak self] querry in
            guard let querry = querry else {
                return
            }
            self?.getPodcast(querryString: querry)
        })
        .disposed(by: disposeBag)
    }
    
    private func getPodcast(querryString: String) {
        self.data.accept([loadingSection])
        self.repository.getPodcast(querryString: querryString).map { podcasts in
            return self.podcastSections(podcasts)
        }
        .subscribe(onNext: { [weak self] result in
            guard let self = self else {
                return
            }
            guard result.count > 0 else {
                self.data.accept([self.emptySection])
                return
            }
            self.data.accept(result)
        }, onError: {  [weak self] error in
            guard let self = self else {
                return
            }
            self.data.accept([self.errorSection])
        })
        .disposed(by: disposeBag)
    }
}
