//
//  PodcastService.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Moya
import RxSwift

public typealias PodcastSearchResult = Single<Result<PodcastSearchResults<Podcast>, Error>>

public protocol PodcastServiceProtocol {
    func getPodcast(querryString: String) -> Observable<[Podcast]>
}

class PodcastService: DataService<APIRouter.PodcastEndpoints>, PodcastServiceProtocol {
    public override init(provider: MoyaProvider<APIRouter.PodcastEndpoints>) {
        super.init(provider: provider)
    }

    func getPodcast(querryString: String) -> Observable<[Podcast]> {
        let endpoint = APIRouter.PodcastEndpoints.searchPodcast(serchString: querryString)
        return super.getRequest(with: endpoint, dataType: PodcastSearchResults<Podcast>.self)
            .map { result in
                switch result {
                case .success(let value):
                    return value.results
                case .failure(let err):
                    throw err
                }
            }
            .asObservable()
    }
    
}
