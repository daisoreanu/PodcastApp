//
//  PodcastDetailsViewModel.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 20.07.2022.
//

import Foundation

import RxSwift

protocol PodcastDetailsProtocol {
    var imagePath: BehaviorSubject<String?> { get }
    var artistName: BehaviorSubject<String?> { get }
    var trackName: BehaviorSubject<String?> { get }
    var releaseDate: BehaviorSubject<String?> { get }
}

class PodcastDetailsViewModel {
    
    private let podcast: Podcast
    
    init(podcast: Podcast) {
        self.podcast = podcast
    }
    
}

extension PodcastDetailsViewModel: PodcastDetailsProtocol {
    var imagePath: BehaviorSubject<String?> {
        BehaviorSubject<String?>(value: podcast.artworkUrl600)
    }
    
    var artistName: BehaviorSubject<String?> {
        BehaviorSubject<String?>(value: podcast.artistName)
    }
    
    var trackName: BehaviorSubject<String?> {
        BehaviorSubject<String?>(value: podcast.trackName)
    }
    
    var releaseDate: BehaviorSubject<String?> {
        var dateAsString: String?
        if let date = podcast.releaseDate {
            let df = DateFormatter.init()
            df.dateFormat = "yyyy-MM-dd"
            dateAsString = "Released on: " + df.string(from: date)
        }
        return BehaviorSubject<String?>(value: dateAsString)
    }
}
