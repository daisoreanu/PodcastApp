//
//  PodcastCollectionItemViewModel.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation

struct PodcastItemViewModel {
    
    let podcast: Podcast
    
    init(podcast: Podcast) {
        self.podcast = podcast
    }
}

extension PodcastItemViewModel: PodcastItemProtocol {
    var imageURL: URL {
        URL(string: podcast.artworkUrl100!)!
    }
    
    var title: String {
        podcast.trackName!
    }
    
    var subtitle: String {
        var subtitle = ""
        if let genres = podcast.genres {
            subtitle = genres.joined(separator: " ")
        }
        return subtitle
    }
}

extension PodcastItemViewModel: Hashable {
    var uuid: String {
        String(podcast.trackId)
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(uuid)
    }
    
    public static func == (lhs: PodcastItemViewModel, rhs: PodcastItemViewModel) -> Bool {
      lhs.uuid == rhs.uuid
    }
}

