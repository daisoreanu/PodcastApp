//
//  PodcastAssembly.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Swinject

class PodcastAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(PodcastCollectionViewModelProtocol.self) { r in
            let podcastRepo = r.resolve(PodcastRepositoryProtocol.self)!
            return PodcastCollectionViewModel(repository: podcastRepo)
        }
        .inObjectScope(.transient)
        
        container.register(PodcastsCollectionViewController.self) { (r, mainCoordinator: MainCoordinator) in
            let podcastViewModel = r.resolve(PodcastCollectionViewModelProtocol.self)!
            return PodcastsCollectionViewController(viewModel: podcastViewModel, coordinator: mainCoordinator)
        }
        .inObjectScope(.transient)
    }
    
}
