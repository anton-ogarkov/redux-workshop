//
//  APIRequestBuilder.swift
//  Core
//
//  Created by Anton Ogarkov on 10/4/17.
//  Copyright © 2017 private. All rights reserved.
//

import Foundation

internal func countriesRequest() -> URLRequest {
    return URLRequest(url: URL(string: "http://services.groupkt.com/country/get/all")!)
}

internal func statesRequest(forCountryCode countryCode: String) -> URLRequest {
    return URLRequest(url: URL(string: "http://services.groupkt.com/state/get/\(countryCode)/all")!)
}
