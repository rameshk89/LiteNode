
// XML Structure

public struct HTML {

    public let root: Element

    public init(_ string: String) throws {
        let parser = Parser(content: string)
        root = try parser.parse()
    }

    public var elementsCount: Int {
        return 1 + countChildren(element: root)
    }

    public func searchElements(_ name: String) -> [Element] {
        if root.name == name {
            var values = [root]
            values.append(contentsOf: searchInChildren(element: root, name: name))
            return values
        }
        return searchInChildren(element: root, name: name)
    }

    private func countChildren(element: Element) -> Int {
        if element.hasChildren {
            var count = element.children.count
            element.children.forEach { count += countChildren(element: $0) }
            return count
        }
        return 0
    }

    private func searchInChildren(element: Element, name: String) -> [Element] {
        var matched = [Element]()
        if element.hasChildren {
            let fromChildren = element.children.map { ele -> [Element] in
                return searchInChildren(element: ele, name: name)
            }
            matched.append(contentsOf: element.children.filter { $0.name == name })
            fromChildren.forEach { matched.append(contentsOf: $0) }
        }
        return matched
    }
}

extension HTML: CustomStringConvertible {
    public var description: String {
        return root.description
    }
}

extension HTML: Decodable {
    public init(from decoder: Decoder) throws {
        let stringValue = try decoder.singleValueContainer().decode(String.self)
        let parser = Parser(content: stringValue)
        root = try parser.parse()
    }
}
