import Foundation

public struct GenericIdentifier<T>: RawRepresentable, Hashable {
    public var hashValue: Int { get { return self.rawValue.hashValue } }
    public let rawValue: String
    
    public init(rawValue: String) { self.rawValue = rawValue }
}

public struct CountryDTO {
    public typealias ID = GenericIdentifier<CountryDTO>
    
    public let code3: ID
    public let code2: String
    public let name: String
    
    public var states: [StateDTO.ID] = []
    
    init(code3: ID, code2: String, name: String) {
        self.code3 = code3
        self.code2 = code2
        self.name = name
    }
}

public struct StateDTO {
    public typealias ID = GenericIdentifier<StateDTO>
    
    public let id: ID
    public let countryName: String
    public let name: String
    public let abbr: String
    public let area: String
    public let largest_city: String
    public let capital: String
}
