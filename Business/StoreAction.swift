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
    case statesUpdated(CountryDTO.ID, [StateDTO])
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

public func constructStateUpdateAC(_ countryCode: CountryDTO.ID) -> (@escaping Store.Dispatch) -> () {
    return { dispatch in
        Network.dataRequest(Network.statesRequest(forCountryCode: countryCode.rawValue))
            .chain(Parser.parseStatesResponse)
            .onComplete(completion: { statesResult in
            switch statesResult {
            case .value(let states):
                dispatch(.statesUpdated(countryCode, states))
            case .error(let error):
                print("Got error: \(error)")
            }
        })
    }
}
