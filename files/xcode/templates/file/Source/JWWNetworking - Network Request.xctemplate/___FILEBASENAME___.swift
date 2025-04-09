import Foundation
import JWWNetworking

/// <#Documentation#>
struct ___FILEBASENAMEASIDENTIFIER___: NetworkRequest {
    typealias Output = Response

    /// The response body for the `___FILEBASENAMEASIDENTIFIER___`.
    struct Response: Codable {
       <#Response Payload#>
    }

    let url: URL? = nil
    let body: Data? = nil
    let method: HTTPMethod = .get
    let path: String
    let queryItems: [URLQueryItem] = []
    let headers: [HTTPRequestHeaderKey: String] = [
        .contentType: "application/json"
    ]

    init(<#Initializer Inputs#>) {
        self.path = <#Path#>
    }

}
