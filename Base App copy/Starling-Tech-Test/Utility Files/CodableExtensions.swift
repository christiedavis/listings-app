//
//  CodableExtensions.swift
//  Starling-Tech-Test
//
//  Created by Christie Davis on 27/07/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit
import Alamofire

public enum ServiceError: Error {
    case notimplemented
    case invalidData
    case forcedUpgrade
    case serviceMaintenance
    case requestFailed
    case invalidEndpoint
    case noResponseData
    case invalidDataDecoding
    case invalidAuth
    case unknown
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    var dictionary: [String: Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

// Adapted from https://stackoverflow.com/a/42529641/2853537
extension Alamofire.SessionManager {
    @discardableResult
    open func requestWithoutCache(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        
        do {
            if var urlRequest: URLRequest = try? URLRequest(url: url, method: method, headers: headers) {
                urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
                urlRequest.timeoutInterval = 30 // <<== less timeout
                let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
                return request(encodedURLRequest)
            }
            return request(url)
        } catch {
            return request(url)
        }
    }
}
