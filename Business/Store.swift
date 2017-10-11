//
//  Store.swift
//  Business
//
//  Created by Anton Ogarkov on 10/6/17.
//  Copyright © 2017 private. All rights reserved.
//

import Foundation
import Core

public struct StoreState {
    public var countries: [CountryDTO.ID: CountryDTO] = [:]
    public var states: [StateDTO.ID : StateDTO] = [:]
    
    public func statesByCountry(countryCode: CountryDTO.ID) -> [StateDTO] {
        return countries[countryCode]?.states.flatMap({states[$0]}) ?? []
    }
}

public class Store {
    public typealias Subscriber = (StoreState) -> ()
    public typealias Dispatch = (StoreAction) -> ()
    public typealias BoundActionCreator = () -> ()

    private var subscribers = [UUID: Subscriber]()
    
    public private(set) var state = StoreState()
    
    public init() {}
    
    @discardableResult public func subscribe(subscriber: @escaping Subscriber) -> UUID {
        let newUUID = UUID()
        self.subscribers[newUUID] = subscriber
        
        return newUUID
    }
    
    public func unsubscribe(uuid: UUID) {
        self.subscribers[uuid] = nil
    }
    
    internal func dispatch(action: StoreAction) {
        mainReducer(currentState: &self.state, action: action)
        self.subscribers.forEach { $0.value(self.state) }
    }
    
    public func bind(worker: @escaping (@escaping Dispatch) -> ()) -> BoundActionCreator {
        return { worker(self.dispatch(action:)) }
    }
}


// MARK: - Reducers

func mainReducer(currentState: inout StoreState, action: StoreAction) {
    switch action {
    case .countriesUpdated(let newCountries):
        let zippedCountries = zip(newCountries.map({$0.code3}), newCountries)
        currentState.countries = Dictionary(uniqueKeysWithValues: zippedCountries)
    case .statesUpdated(let countryId, let states):
        let keys = states.map({$0.id})
        let zippedStates = zip(keys, states)
        let newStates = Dictionary(uniqueKeysWithValues: zippedStates)
        currentState.countries[countryId]?.states = keys
        currentState.states = newStates
    }
}
