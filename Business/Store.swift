//
//  Store.swift
//  Business
//
//  Created by Anton Ogarkov on 10/6/17.
//  Copyright © 2017 private. All rights reserved.
//

import Foundation

public struct Country {
    let code2: String
    let code3: String
    let name: String
}

public struct State {
    let countries: [Country] = []
}

public class Store {
    private var state = State()
}
