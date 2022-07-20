//
//  CoordinatorAssembly.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Swinject

class CoordinatorAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MainCoordinator.self) { (r, navigationController: UINavigationController) in
            return MainCoordinator(navigationController: navigationController)
        }
        .inObjectScope(.container)
    }
    
}

