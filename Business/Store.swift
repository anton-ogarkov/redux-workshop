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
    public var countries: [CountryDTO] = []
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
        self.subscribers.forEach { $1(self.state) }
    }
    
    public func bind(worker: @escaping (@escaping Dispatch) -> ()) -> BoundActionCreator {
        return { worker(self.dispatch(action:)) }
    }
}


// MARK: - Reducers

func mainReducer(currentState: inout StoreState, action: StoreAction) {
    switch action {
    case .countriesUpdated(let newCountries):
        currentState.countries = newCountries
    }
}
