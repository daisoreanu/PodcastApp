//
//  APIRouter.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Moya

public enum APIRouter {
    static var baseUrl: URL {
        return URL(string: "https://itunes.apple.com")!
    }
}

