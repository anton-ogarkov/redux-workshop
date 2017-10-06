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
    
    var value: Result<Value>? {
        didSet {
            self.value.map(self.reportResult)
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
