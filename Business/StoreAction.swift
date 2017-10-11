//
//  StoreAction.swift
//  Business
//
//  Created by Anton Ogarkov on 10/6/17.
//  Copyright © 2017 private. All rights reserved.
//

import Foundation
import Core

public enum StoreAction {
    case countriesUpdated([CountryDTO])
}

public func constructCountryUpdateAC() -> (@escaping Store.Dispatch) -> () {
    return { dispatch in
        Network.dataRequest(Network.countriesRequest()).chain(Parser.parseCountriesResponse).onComplete { (countriesResult) in
            switch countriesResult {
            case .value(let countries):
                dispatch(.countriesUpdated(countries))
            case .error(let error):
                print("Got error: \(error)");
            }
        }
    }
}
