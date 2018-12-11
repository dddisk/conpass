import UIKit

struct ConnpassViewModel: Codable{
    var events: [Events]
    struct Events: Codable {
        var title: String
        var event_url: String
        var started_at: String
    }
}

