//
//  BaseNetworkService.swift
//  ListingsApp
//
//  Created by Christie Davis on 4/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

internal protocol BaseServiceProtocol {
    
    func request<T: Encodable, E: Decodable >(method: HTTPMethod, path: String, requestDTO: T?) -> Promise<E>
}

class BaseNetworkService {
    
    internal let defaultEndpointEncoder: JSONEncoder
    internal let defaultEndpointDecoder: JSONDecoder
    
    internal var sessionManager: SessionManager = Alamofire.SessionManager.default
    let consumerKey = "1B52E3035B3082867BB52FD91B4607BB"
    let consumerSecret = "2BCF30BC18856EDFE053D855A77B6485"
    let oauthToken = "69B715609DD5815B7E4B90C5338C0F16"
    let tokenSecret = "C53F68AB74D371F97024D7FBF18D88C0"
    
    internal func retrieveBasedURL(_ endpoint: String) -> URL? {
        return URL(string: "https://api.trademe.co.nz/v1/\(endpoint)?file_format=json")
    }
    
    /// retrieves the headers for the service endpoint.
    internal var headers: HTTPHeaders? {
        var headerDict: [String: String] = [:]
        
        headerDict["Authorization"] = "OAuth oauth_consumer_key=" + self.consumerKey +
        ", oauth_signature_method=PLAINTEXT, oauth_signature=" + consumerSecret
        headerDict["Accept"] = "application/json"
        headerDict["User-Agent"] = "christie-davis"
        return headerDict
    }
}

extension BaseNetworkService: BaseServiceProtocol {

    internal func request<T: Encodable, E: Decodable >(method: HTTPMethod, path: String, requestDTO: T?) -> Promise<E> {
        let dict = try? requestDTO.asDictionary()
        return request(method: method, path: path, parameters: dict)
    }

    internal func request<T: Decodable>(method: HTTPMethod, path: String, parameters: Parameters? = nil) -> Promise<T> {
        guard let url = retrieveBasedURL(path) else {
            return Promise(error: ServiceError.invalidEndpoint)

        }
        return self.request(url: url, method: method, parameters: parameters)
    }

    internal func request<T: Decodable>(url: URL, method: HTTPMethod, parameters: Parameters? = nil) -> Promise<T> {

        guard let sessionManager = sessionManager else {
            return Promise(error: ServiceError.requestFailed)
        }

        return Promise { seal in

            sessionManager.requestWithoutCache(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<400)
                .response(completionHandler: { response in

                    if let error = response.error {
                        seal.reject(error)

                    } else {

                        guard let responseData = response.data else {
                            seal.reject(ServiceError.noResponseData)
                            return
                        }

                        do {

                            let result = try self.defaultEndpointDecoder.decode(T.self, from: responseData)

                            seal.fulfill(result)
                        } catch let error {
                            seal.reject(ServiceError.invalidDataDecoding)
                            return
                        }
                    }
                })
        }
    }
}
