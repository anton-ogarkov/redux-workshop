import Foundation

public enum ParserError: Error {
    case badDictionry(Any)
    case badArray(Any)
    case badString(Any)
    case badKey(key: String, dict:[String: Any])
}

public struct Parser {
    static func json(_ data: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    static func dictionary(_ any: Any) throws -> [String: Any] {
        guard let dict = any as? [String: Any] else {
            throw ParserError.badDictionry(any)
        }
        return dict
    }
    
    static func array(_ any: Any) throws -> [Any] {
        guard let array = any as? [Any] else {
            throw ParserError.badArray(any)
        }
        return array
    }
    
    static func string(_ any: Any) throws -> String {
        guard let str = any as? String else {
            throw ParserError.badString(any)
        }
        return str
    }
    
    static func key(_ key: String, _ dictionary: [String: Any]) throws -> Any {
        guard let val = dictionary[key] else {
            throw ParserError.badKey(key: key, dict: dictionary)
        }
        return val
    }
    
    static func key(_ key: String) -> ([String: Any]) throws -> Any {
        return { dictionary in
            return try self.key(key, dictionary)
        }
    }
    
    public static func parseCountriesResponse(_ data: Data) -> Future<[CountryDTO]> {
        return Promise(value: data)
            .map(json).map(dictionary)
            .map(key("RestResponse")).map(dictionary)
            .map(key("result")).map(array)
            .map { try $0.map(parseCountryDTO) }
    }
    
    static func parseCountryDTO(_ any: Any) throws -> CountryDTO {
        let dictionary = try self.dictionary(any)
        return CountryDTO(
            code2: try string(key("alpha2_code", dictionary)),
                          code3: try string(key("alpha3_code", dictionary)),
                          name: try string(key("name", dictionary))
        )
    }
}
