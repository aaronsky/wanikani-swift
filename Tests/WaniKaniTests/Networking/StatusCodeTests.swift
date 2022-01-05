import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class StatusCodeTests: XCTestCase {
    func testFlag() {
        XCTAssertTrue(StatusCode.ok.isSuccess)
        XCTAssertFalse(StatusCode.unauthorized.isSuccess)
        XCTAssertFalse(StatusCode.notFound.isSuccess)
        XCTAssertFalse(StatusCode.internalServerError.isSuccess)
    }
}
