//
//  StoreAction.swift
//  Business
//
//  Created by Anton Ogarkov on 10/6/17.
//  Copyright © 2017 private. All rights reserved.
//

import Foundation

public enum StoreAction {
    case countriesUpdated([Country])
}

public func constructCountryUpdateAC() -> (Store.Dispatch) -> () {
    return { dispatch in
        let newCountries: [Country] = [
            Country(code2: "UA", code3: "UA?", name: "Ukraine"),
            Country(code2: "US", code3: "USA", name: "United States Of America"),
            Country(code2: "CX", code3: "CXR", name: "Christmas Island"),
            Country(code2: "CC", code3: "CCK", name: "Cocos (Keeling) Islands")
        ]
        dispatch(.countriesUpdated(newCountries))
    }
}
