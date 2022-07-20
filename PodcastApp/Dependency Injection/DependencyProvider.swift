//
//  DependencyProvider.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Swinject

class DependencyProvider {
    
    private let container: Container
    private let assembler: Assembler
    
    private init(container: Container = Container(), assemblies: [Assembly] = DependencyProvider.assemblies) {
        self.container = container
        self.assembler = Assembler(assemblies, container: container)
    }
    
    static let shared = DependencyProvider()
    
    private static let assemblies: [Assembly] = [
        PodcastRepositoryAssembly(),
        CoordinatorAssembly(),
        PodcastAssembly(),
        PodcastDetailsAssembly()
    ]
    
    
}

extension DependencyProvider {
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return self.assembler.resolver.resolve(serviceType)
    }
    
    func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service? {
        return self.assembler.resolver.resolve(serviceType, argument: argument)
    }
    
    func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        return self.assembler.resolver.resolve(serviceType, arguments: arg1, arg2)
    }
}

