//
//  DecodableResponses.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation

public struct PodcastSearchResults<T: Decodable>: Decodable {
    let resultCount: Int?
    let results: [T]
}
