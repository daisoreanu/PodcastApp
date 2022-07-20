//
//  MoyaExtension.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Moya

public protocol PodcastTargetType {

    ///  The JSON validation that will be performed on the request result. Default is `JSONDecoder()`.
    var jsonValidator: JSONDecoder { get }

}

public typealias TargetTypeExtension = PodcastTargetType & TargetType
