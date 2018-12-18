//
//  ApiService.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/30/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveKit

enum ApiAction: String {
    case restaurants
}

class ApiService {
    
    private let queue = DispatchQueue(label: ApiConfig.queueName, attributes: [.concurrent])
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .custom{ (codingKeys) -> CodingKey in
            var value = codingKeys.last!.stringValue
            
            if !value.isEmpty {
                let range = ...value.index(after: value.startIndex)
                
                value = value.replacingCharacters(in: range, with: value[range].lowercased())
            }
            
            return AnyCodingKey(stringValue: value)!
        }

        return decoder
    }()
    
    func query<T: Decodable>(_ action: ApiAction, method: HTTPMethod = .get, parameters: Parameters? = nil) -> Signal<T, ApiError> {
        let queue = self.queue
        let decoder = self.decoder
        
        return Signal { observer in
            guard
                let url = URL(string: ApiConfig.endPoint)?.appendingPathComponent(action.rawValue)
                else {
                    observer.failed(.invalidParams)

                    return NonDisposable.instance
            }

            let headers = ApiConfig.baseHeaders.merging([ApiConfig.authorizationHeader: ApiConfig.authorization]) { _, v in v }
            let request = Alamofire
                .request(url, method: method, parameters: parameters, headers: headers)
                .responseData(queue: queue) { dataResponse in
                    guard let responseData = dataResponse.value else {
                        if let error = dataResponse.error {
                            return observer.failed(.networkError(error: error))
                        } else {
                            return observer.failed(.emptyResponse)
                        }
                    }
                    
                    let data: T
                    
                    do {
                        data = try decoder.decode(T.self, from: responseData)
                    } catch {
                        return observer.failed(.failedToParse(error: error))
                    }
                    
                    observer.completed(with: data)
            }

            return BlockDisposable {
                request.cancel()
            }
        }
    }
    
}
