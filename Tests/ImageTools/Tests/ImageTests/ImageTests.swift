import XCTest
import CCurl
@testable import ImageTools

///
/// Tests the integrity of the image.
///

class ImageTests: XCTestCase {

    let imageTools = ImageTools()
    let minimumCURLVersion = Version(major: 7, minor: 51, patch: 0)
    
    /// Checks that libcurl has a version equal or greater than 7.51.0.
    func testCURLVersion() {
        XCTAssertTrue(imageTools.cURLVersion >= minimumCURLVersion)
    }

    /// Checks that libcurl supports HTTP/2.
    func testHTTP2Support() {
        XCTAssertTrue(imageTools.hasHTTP2Support)
    }

    /// Checks that HTTP/2 requests succeed.
    func testSendHTTP2Request() {

        let curlHandle = curl_easy_init()

        defer {
            curl_easy_cleanup(curlHandle)
        }

        let url = "https://nghttp2.org"
        
        url.withMutableCString {
            curlHelperSetOptString(curlHandle, CURLOPT_URL, $0)
        }

        curlHelperSetOptInt(curlHandle, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_2_0)

        var resultData = CURLWriteStorage()

        curlHelperSetOptWriteFunc(curlHandle, &resultData) { (ptr, size, nMemb, privateData) -> Int in

            let storage = privateData?.assumingMemoryBound(to: CURLWriteStorage.self)
            let realsize = size * nMemb

            var bytes: [UInt8] = [UInt8](repeating: 0, count: realsize)
            memcpy(&bytes, ptr!, realsize)

            for byte in bytes {
                storage?.pointee.data.append(byte)
            }

            return realsize

        }

        let result = curl_easy_perform(curlHandle)
        let responseBody = String(bytes: resultData.data, encoding: .utf8)!

        XCTAssertEqual(result, CURLE_OK)
        XCTAssertTrue(responseBody.hasPrefix("HTTP/2 200"))

    }

    static var allTests = [
        ("testCURLVersion", testCURLVersion),
        ("testHTTP2Support", testHTTP2Support),
        ("testSendHTTP2Request", testSendHTTP2Request)
    ]

}

class CURLWriteStorage {
    var data = [UInt8]()
}
