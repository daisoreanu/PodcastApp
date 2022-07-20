//
//  DataService.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import Moya
import RxSwift

public class DataService<Target> where Target: TargetTypeExtension {

    //    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "com.myHeritage.background", qos: .background, attributes: [.concurrent]))
    private let provider: MoyaProvider<Target>
    private let mainScheduler = MainScheduler.instance
    private let disposeBag = DisposeBag()
    
    public init(provider: MoyaProvider<Target>) {
        self.provider = provider
    }

}

extension DataService {
    public func getRequest<T: Decodable>(with target: Target, dataType: T.Type) -> Single<Result<T, Error>> {
        let request = provider.rx.request(target).observe(on: mainScheduler)
        return request.flatMap { response -> Single<Result<T,Error>> in
            do {
                
                if let JSONString = String(data: response.data, encoding: String.Encoding.utf8) {
                    print(JSONString)
                }
                
                let jsonDecoder = target.jsonValidator
                let data: T = try response.map(dataType, using: jsonDecoder)
                return Single.just(.success(data))
            }
            catch {
                return Single.just(.failure(error))
            }
        }
        
//        let request = provider.rx.request(target).observe(on: mainScheduler)
//        return Single.create { [unowned self] single in
//            request.subscribe { response in
//                do {
//                    let jsonDecoder = target.jsonValidator
//                    let data: T = try response.map(dataType, using: jsonDecoder)
//                    single(.success(.success(data)))
//                } catch {
//                    single(.failure(error))
//                }
//            } onFailure: { error in
//                single(.failure(error))
//            }.disposed(by: self.disposeBag)
//            return Disposables.create()
//        }
//        .observe(on: mainScheduler)
    }
}

//TODO: Should it be implemented?
public enum APIError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}




