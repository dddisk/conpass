import RxSwift
import RxCocoa
import UIKit

struct ConnpassStruct: Codable {
    var events: [Events]
    struct Events: Codable {
        var title: String
        var eventUrl: String
        var startedAt: String
        private enum CodingKeys: String, CodingKey {
            case title
            case eventUrl = "event_url"
            case startedAt = "started_at"
        }
    }
}

class ConnpassViewModel {
    let connpassModel = ConnpassModel()
}

