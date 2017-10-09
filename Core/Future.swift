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
