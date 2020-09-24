//
//  File.swift
//  
//
//  Created by Ramesh Kumar on 12/9/19.
//

public extension HTML {

    struct Element {

        public let name: String

        public var value: String?

        public var children: [Element]

        public var attributes: [Attribute]

        var isValueType: Bool {
            return value != nil && !value!.isEmpty
        }

        public var hasChildren: Bool {
            return !children.isEmpty
        }

        public init(name: String, value: String?, children: [Element] = [], attributes: [Attribute] = []) {
            self.name = name
            self.value = value
            self.children = children
            self.attributes = attributes
        }
    }

    struct Attribute {
        let name: String
        let value: String
    }

}

extension HTML.Element: CustomStringConvertible {

    public var description: String {
        let attrString = attributes.isEmpty ? "" : attributes.map({ " \($0.name)=\($0.value)" }).joined()
        if hasChildren {
            let childrenString = children.map({ $0.description }).joined()
            return String(format: "<%@%@>%@</%@>", name, attrString, childrenString, name)
        } else {
            let valueString = value ?? ""
            return String(format: "<%@%@>%@</%@>", name, attrString, valueString, name)
        }
    }
}
