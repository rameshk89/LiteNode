
//
//  File.swift
//  
//
//  Created by Ramesh Kumar on 12/9/19.
//

import Foundation

public enum ParserErrors: Error  {
    case invalid
    case empty
}

public extension String {

    var stripped: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }

    var trimmed: String {
      return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func parseParameter() -> [(key:String, value:String)] {
        let string = self
        guard !string.isEmpty else {
            return []
        }
        let parts = string.components(separatedBy: ",")
        let asPairs = parts.map { partition(string: $0, atFirstOccurrenceOf: "=") }
        let result = asPairs.map { (key: $0.trimmed, value: $1.trimmed) }
        return result
    }

    func partition(string: String, atFirstOccurrenceOf substring: String) -> (String, String) {
        guard let index = string.range(of: substring)?.lowerBound else {
            return (string, "")
        }
        return (String(string[..<index]),
                String(string[string.index(after: index)...]))
    }

}
