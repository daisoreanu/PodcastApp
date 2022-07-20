//
//  Podcast.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation

public struct Podcast: Decodable {
    let wrapperType, kind: String?
    let trackId: Int
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionViewURL, feedURL, trackViewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let trackRentalPrice, collectionHDPrice, trackHDPrice, trackHDRentalPrice: Int?
    let releaseDate: Date?
    let collectionExplicitness, trackExplicitness: String?
    let trackCount, collectionID: Int?
    let country, currency, primaryGenreName, contentAdvisoryRating: String?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?
}
