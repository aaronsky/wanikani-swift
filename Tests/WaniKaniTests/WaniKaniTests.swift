import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class WaniKaniTests: XCTestCase {
    func testSendRequest() async throws {
        let testData = try TestData(testCase: .success)
        let response = try await testData.client.send(testData.resources.contentResource)
        XCTAssertEqual(testData.resources.content, response.data)
    }

    func testSendRequestWithPagination() async throws {
        let testData = try TestData(testCase: .successPaginated)
        let response = try await testData.client.send(
            testData.resources.paginatedContentResource,
            pageOptions: PageOptions(afterID: 10)
        )
        XCTAssertEqual(testData.resources.paginatedContent, response.data)
        //        XCTAssertNotNil(response.data.page)
    }

    func testSendRequestWithBody() async throws {
        let testData = try TestData(testCase: .successHasBody)
        let response = try await testData.client.send(testData.resources.bodyAndContentResource)
        XCTAssertEqual(testData.resources.bodyAndContent, response.data)
    }

    func testPaginateStreamRequest() async throws {}

    func testSendWithInvalidResponse() async throws {
        let testData = try TestData(testCase: .badResponse)
        do {
            _ = try await testData.client.send(testData.resources.contentResource)
            XCTFail("Expected to have thrown an error, but task fulfilled normally")
        } catch {}
    }

    func testSendWithUnsuccessfulResponse() async throws {
        let testData = try TestData(testCase: .unsuccessfulResponse)
        do {
            _ = try await testData.client.send(testData.resources.contentResource)
            XCTFail("Expected to have thrown an error, but task fulfilled normally")
        } catch {}
    }

    private struct TestData {
        enum Case {
            case success
            case successPaginated
            case successHasBody
            case badResponse
            case unsuccessfulResponse
            case noData
        }

        var configuration: WaniKani.Configuration = .default
        var client: WaniKani
        var resources = MockResources()

        init(
            testCase: Case = .success
        ) throws {
            let responses: [(Data, URLResponse)]

            switch testCase {
            case .success:
                responses = try [MockData.mockingSuccess(with: resources.content, url: configuration.version.baseURL)]
            case .successPaginated:
                responses = try [
                    MockData.mockingSuccess(with: resources.paginatedContent, url: configuration.version.baseURL)
                ]
            case .successHasBody:
                responses = try [
                    MockData.mockingSuccess(with: resources.bodyAndContent, url: configuration.version.baseURL)
                ]
            case .badResponse:
                responses = [MockData.mockingIncompatibleResponse(for: configuration.version.baseURL)]
            case .unsuccessfulResponse:
                responses = [MockData.mockingUnsuccessfulResponse(for: configuration.version.baseURL)]
            case .noData:
                responses = []
            }

            client = WaniKani(configuration: configuration, transport: MockTransport(responses: responses))
            client.token = "a valid token, i guess"

            XCTAssertEqual(client.token, client.configuration.token)
        }
    }
}
