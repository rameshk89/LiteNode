import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LiteNodeTests.allTests),
        testCase(LiteNodeCodableTest.allTests),
    ]
}
#endif
