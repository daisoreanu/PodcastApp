//
//  PodcastDetailsAssembly.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 20.07.2022.
//

import Foundation
import Swinject

class PodcastDetailsAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(PodcastDetailsProtocol.self) { (r, podcast: Podcast) in
            return PodcastDetailsViewModel(podcast: podcast)
        }
        .inObjectScope(.transient)
        
        container.register( PodcastDetailsViewController.self) { (r, podcast: Podcast, coordinator: PodcastCoordinator) in
            let podcastViewModel = r.resolve(PodcastDetailsProtocol.self, argument: podcast)!
            return PodcastDetailsViewController(viewModel: podcastViewModel, coordinator: coordinator)
        }
        .inObjectScope(.transient)
    }
    
}
