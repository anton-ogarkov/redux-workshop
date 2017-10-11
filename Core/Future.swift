//
//  Future.swift
//  Core
//
//  Created by Anton Ogarkov on 10/6/17.
//  Copyright © 2017 private. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case value(Value)
    case error(Error)
}

public class Future <Value> {
    public typealias Completion = (Result<Value>) -> ()
    
    fileprivate var result: Result<Value>? {
        didSet {
            self.result.map(self.reportResult)
        }
    }
    
    private var completions = [Completion]()
    
    private func reportResult(result: Result<Value>) {
        self.completions.forEach { (completion) in
            completion(result)
        }
    }
    
    public func onComplete(completion: @escaping Completion) {
        completions.append(completion)
        
        self.result.map(completion)
    }
}

public extension Future {
    public func chain<NewValue>(_ futureBuilder: @escaping (Value) throws -> Future<NewValue> ) -> Future<NewValue> {
        let newPromise = Promise<NewValue>()
        
        self.onComplete { result in
            switch result {
            case .value(let oldValue) :
                do {
                    let newFuture = try futureBuilder(oldValue)
                    newFuture.onComplete(completion: { (newResult) in
                        switch newResult {
                        case .value(let newValue):
                            newPromise.resolve(value: newValue)
                        case .error(let error):
                            newPromise.reject(error: error)
                        }
                    })
                } catch {
                    newPromise.reject(error: error)
                }
            case .error(let error) :
                newPromise.reject(error: error)
            }
        }

        return newPromise
    }
    
    public func map<NewValue>(_ transform: @escaping (Value) throws -> (NewValue) ) -> Future<NewValue> {
        return self.chain {
            Promise(value: try transform($0))
        }
    }
}

public class Promise<Value> : Future<Value> {
    init(value: Value? = nil) {
        super.init()
        
        self.result = value.map({.value($0)})
    }
    
    init(error: Error) {
        super.init()

        self.result = .error(error)
    }
    
    func resolve(value: Value) {
        self.result = .value(value)
    }
    
    func reject(error: Error) {
        self.result = .error(error)
    }
}
