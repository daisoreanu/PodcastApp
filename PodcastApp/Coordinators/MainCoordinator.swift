//
//  MainCoordinator.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject  {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var rootController: CoordinatedController? { get set }
    
    func start()
}

protocol CoordinatedController where Self: UIViewController {
    var coordinator: Coordinator { get set }
}

class BaseCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var rootController: CoordinatedController?
    fileprivate let dependencyProvider = DependencyProvider.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
    func start() {}
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        guard let rootController = rootController else {
            return
        }
        if fromViewController === rootController {
            childDidFinish(rootController.coordinator)
        }
    }
}

class MainCoordinator: BaseCoordinator {
    
    override func start() {
        let vc = dependencyProvider.resolve(PodcastsCollectionViewController.self, argument: self)!
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showPodcastDetails(podcasst: Podcast) {
        let child = PodcastCoordinator(podcast: podcasst,
                                       navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
}

class PodcastCoordinator: BaseCoordinator {
    
    weak var parentCoordinator: MainCoordinator?
    private var childNavController = UINavigationController()
    private var podcast: Podcast
    
    init(podcast: Podcast, navigationController: UINavigationController) {
        self.podcast = podcast
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        childNavController.delegate = self
        rootController = PodcastContainerViewController(coordinator: self)
        rootController!.add(child: childNavController)
        let vc = dependencyProvider.resolve(PodcastDetailsViewController.self, arguments: podcast, self)!
        childNavController.pushViewController(vc, animated: false)
        navigationController.present(rootController!, animated: true)
    }
    
    func dismissScreensStack() {
        navigationController.dismiss(animated: true)
        super.childDidFinish(self)
    }
    
}

class PodcastContainerViewController: UIViewController, CoordinatedController {
    
    var coordinator: Coordinator
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Unsuported method, use DI constructor.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("View controller created from a storyboard is unsupported in favor of dependency injection.")
    }
    
}
