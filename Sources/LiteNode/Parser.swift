//
//  File.swift
//  
//
//  Created by Ramesh Kumar on 12/9/19.
//
import Foundation

let charTagBegin: Character = "<"
let charTagEnd = Character(">")
let tagClosingStart = "</"

struct Stack<T> {
    var data: [T] = []
    mutating func push(_ value: T) {
        data.append(value)
    }
    mutating func pop() -> T? {
        guard !isEmpty else {
            return nil
        }
        return data.removeLast()
    }
    var isEmpty: Bool {
        return data.isEmpty
    }
}


extension String.SubSequence {
    var isXMLTag: Bool {
        guard !isEmpty else {
            return false
        }
        return self[startIndex] == charTagBegin
    }
    var isEndXMLTag: Bool {
        return self.prefix(2) == tagClosingStart
    }
    var isStartXMLTag: Bool {
        return self[startIndex] == charTagBegin && self.prefix(2) != tagClosingStart
    }
}


class Parser {

    var content: String
    var begin: String.Index
    var end: String.Index

    var stack = Stack<HTML.Element>()

    init(content: String) {
        self.content = content.replacingOccurrences(of: "\n", with: "")
        begin = self.content.startIndex
        end = self.content.index(before: self.content.endIndex)
    }

    func parse() throws -> HTML.Element {
        while begin < end {
            let current = content[begin...end]
            if current.isEmpty {
                break
            }
            if current.isXMLTag {
                let isEndTag = current.isEndXMLTag
                let index = current.firstIndex(of: charTagEnd)!
                if !isEndTag {
                    let nameString = current.dropFirst().prefix(upTo: index)
                    let attributesString = nameString.split(separator: Character(" "))
                    let name = attributesString.first ?? nameString
                    let attributes = attributesString.dropFirst()
                        .map { String($0).parseParameter() }
                        .map { $0.map({ HTML.Attribute(name: $0.key, value: $0.value.stripped) }) }
                        .reduce([], +)

                    stack.push(HTML.Element(name: String(name), value: nil, attributes: attributes))
                    begin = content.index(begin, offsetBy: nameString.count + 2)
                } else {
                    guard let last = stack.pop() else {
                        throw ParserErrors.invalid
                    }
                    let name = last.name
                    begin = content.index(begin, offsetBy: name.count + 3)

                    if stack.isEmpty {
                        stack.push(last)
                    } else {
                        guard var last2 = stack.pop() else {
                            assert(false, "Should not be empty")
                        }
                        last2.children.append(last)
                        stack.push(last2)
                    }
                }
            } else {
                if stack.isEmpty {
                    if let index = current.firstIndex(of: charTagBegin) {
                        begin = index
                        continue
                    } else {
                        throw ParserErrors.invalid
                    }
                }
                guard var last = stack.pop() else {
                    assert(false, "Should not be empty")
                }
                if let index = current.firstIndex(of: charTagBegin) {
                    let value = current.prefix(upTo: index)
                    last.value = String(value)
                    begin = content.index(begin, offsetBy: value.count)
                }
                else {
                    begin = content.index(begin, offsetBy: current.count)
                }
                stack.push(last)
            }
        }
        var poped = stack.pop()
        while !stack.isEmpty {
            poped = stack.pop()
        }
        guard poped != nil else {
            throw ParserErrors.empty
        }
        return poped!
    }
}
