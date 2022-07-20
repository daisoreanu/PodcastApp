//
//  PodcastRepository.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import RxSwift
import Moya

protocol PodcastRepositoryProtocol {
    func getPodcast(querryString: String) -> Observable<[Podcast]>
}

class PodcastRepository: PodcastRepositoryProtocol {
    private let service: PodcastServiceProtocol
    init(service: PodcastServiceProtocol) {
        self.service = service
    }
    func getPodcast(querryString: String) -> Observable<[Podcast]> {
        return service.getPodcast(querryString: querryString)
    }
}
