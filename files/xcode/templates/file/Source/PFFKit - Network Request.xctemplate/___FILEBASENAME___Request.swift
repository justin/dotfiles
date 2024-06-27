import Foundation

/// <#Documentation#>
struct ___FILEBASENAMEASIDENTIFIER___Request: NetworkRequest {
    typealias Output = Response

    let apiVersion: APIVersion = .v1
    let league: League = .nfl
    let method: HTTPMethod = .get
    let path: String
    let queryItems: [URLQueryItem] = []
    let headers: [HTTPRequestHeaderKey: String] = [:]

    init(<#Initializer Inputs#>) {
        self.path = <#Path#>
    }

    struct Response: Codable {
       <#Response Payload#>
    }

}
