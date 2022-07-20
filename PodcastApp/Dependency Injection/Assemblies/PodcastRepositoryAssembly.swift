//
//  PodcastRepositoryAssembly.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Swinject
import Moya
import RxSwift

class PodcastRepositoryAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MoyaProvider<APIRouter.PodcastEndpoints>.self) { r in
            MoyaProvider<APIRouter.PodcastEndpoints>()
        }
        .inObjectScope(.container)
        
        container.register(PodcastServiceProtocol.self) { r in
            let moyaProvider = r.resolve(MoyaProvider<APIRouter.PodcastEndpoints>.self)!
            return PodcastService(provider: moyaProvider)
        }
        .inObjectScope(.container)
        
        container.register(PodcastRepositoryProtocol.self) { r in
            let podcastService = r.resolve(PodcastServiceProtocol.self)!
            return PodcastRepository(service: podcastService)
        }
        .inObjectScope(.container)
    }
    
}
