//
//  BaseNetworkService.swift
//  Starling-Tech-Test
//
//  Created by Christie Davis on 27/07/19.
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
    
    internal var sessionManager: SessionManager?
    let customAuthToken = "MgCM6iJpYTtqYWhVlSi7iknS7uBsfyKZYWi0Yh3hXLrKBsmVGBSlxUtJ3doJXRFf"
    
    internal func setSessionDelegateTaskWillPerformHTTPRedirection(_ taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?) {
        sessionManager?.delegate.taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection
    }
    
    init(encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.defaultEndpointEncoder = encoder
        self.defaultEndpointDecoder = decoder
        self.sessionManager = initilizeSessionManager()
    }
    
    internal func retrieveBasedURL(_ endpoint: String) -> URL? {
        return URL(string: "https://api-sandbox.starlingbank.com/api/v2\(endpoint)")
    }
    
    /// retrieves the headers for the service endpoint.
    internal var headers: HTTPHeaders? {
        var headerDict: [String: String] = [:]
        
        headerDict["Authorization"] = "Bearer " + customAuthToken
        
        headerDict["Accept"] = "application/json"
        headerDict["User-Agent"] = "christie-davis"
        return headerDict
    }
    
    func getCertificateName() -> String {
        return "Baltimore CyberTrust Root"
    }
    
    /// Create session manager
    func initilizeSessionManager() -> SessionManager? {
        return Alamofire.SessionManager.default
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
