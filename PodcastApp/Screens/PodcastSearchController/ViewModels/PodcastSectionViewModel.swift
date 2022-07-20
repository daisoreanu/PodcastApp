//
//  PodcastSection.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation

class PodcastSectionViewModel {
    
    var section: PodcastSection
    var podcastSectionItems: [PodcastSectionItem]
    
    init(section: PodcastSection, podcastSectionItems: [PodcastSectionItem]) {
        self.section = section
        self.podcastSectionItems = podcastSectionItems
    }
    
}

