//
//  APIRequestBuilder.swift
//  Core
//
//  Created by Anton Ogarkov on 10/4/17.
//  Copyright © 2017 private. All rights reserved.
//

import Foundation

public enum Network {
    public static func dataRequest(_ request: URLRequest) -> Future<Data> {
        let promise = Promise<Data>()
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                promise.resolve(value: data)
            } else if let error = error {
                promise.reject(error: error)
            } else {
                fatalError("Inconsistency - neither error, nor data was received. Got response: \(String(describing: response))")
            }
            }.resume()
        return promise
    }

    public static func countriesRequest() -> URLRequest {
        return URLRequest(url: URL(string: "http://services.groupkt.com/country/get/all")!)
    }
    
    public static func statesRequest(forCountryCode countryCode: String) -> URLRequest {
        return URLRequest(url: URL(string: "http://services.groupkt.com/state/get/\(countryCode)/all")!)
    }
    
}
