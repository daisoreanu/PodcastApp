//
//  PodcastEndpoints.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Moya

//TODO: Should I handle the network errors?
public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

public extension APIRouter {
    enum PodcastEndpoints: TargetTypeExtension {
        
        case searchPodcast(serchString: String)
        
        public var baseURL: URL {
            APIRouter.baseUrl
        }
        public var path: String {
            return "search"
        }
        
        public var method: Moya.Method {
            switch self {
                case .searchPodcast( _): return .get
            }
        }
        
        public var task: Task {
            switch self {
            case .searchPodcast(let serchString):
                return .requestParameters(parameters: ["entity": "podcast",
                                                       "term": serchString],
                                          encoding: URLEncoding.default)
            }
        }
        
        public var headers: [String : String]? {
            return ["Content-Type": "application/json"]
        }
        
        public var validationType: ValidationType {
            return .successCodes
        }
        
        public var jsonValidator: JSONDecoder {
            let jsonDecoder = JSONDecoder()
            let df = DateFormatter.init()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            jsonDecoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(df)
            return jsonDecoder
        }
        
    }
}
