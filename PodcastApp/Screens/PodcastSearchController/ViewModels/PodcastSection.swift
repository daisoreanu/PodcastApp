//
//  PodcastSection.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation

enum PodcastSection: Hashable {
    case podcasts(String? = nil)
}

enum PodcastSectionItem: Hashable {
    case startSearch(InstructionItemViewModel = startSearchItemViewModel) //🔭
    case podcast(PodcastItemViewModel)
    case error(InstructionItemViewModel = errorItemViewModel) //🤕
    case empty(InstructionItemViewModel = emptyItemViewModel) //📭
    case loading(UUID)
}

extension PodcastSectionItem {
    static var loadingItemsViewModel: [PodcastSectionItem] {
        return Array(repeatingExpression: PodcastSectionItem.loading(UUID()), count: 10)
    }
    
    static var startSearchItemViewModel: InstructionItemViewModel {
        InstructionItemViewModel(title: "Start searching",
                                 description: "Search for things that you love, i.e.: \"My Heritage\"",
                                 imagePath: "connection_error_ic")
    }
    
    static var emptyItemViewModel: InstructionItemViewModel {
        InstructionItemViewModel(title: "No results",
                                 description: "We weren't able to find any results for your search. Update your search and try again.",
                                 imagePath: "no_results_ic")
    }
    
    static var errorItemViewModel: InstructionItemViewModel {
        InstructionItemViewModel(title: "Error",
                                 description: "Something happend. Keep trying.",
                                 imagePath: "connection_error_ic")
    }
}
