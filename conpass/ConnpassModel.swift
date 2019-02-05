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

//https://dev.classmethod.jp/smartphone/use-rxswift-for-http-networking/
class ConnpassModel {

    private let disposeBag = DisposeBag()
    var searchBar: UISearchBar!
    var keyword: String!
    var resultsfields = BehaviorRelay<[ConnpassStruct.Events]>(value: [])
    //https://qiita.com/_ha1f/items/43b28792d27dbee7133d
    func fetchEvent(keyword: String) -> Single<[ConnpassStruct.Events]> {
    return Single<[ConnpassStruct.Events]>.create { single in
        let connpassApiUrl = "https://connpass.com/api/v1/event/"
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormater.string(from: Date())
        var urlComponents = URLComponents(string: connpassApiUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "keyword", value: keyword)
        ]
        print(keyword)
        //https://qiita.com/KosukeOhmura/items/8b65bdb63da6df95c7a3
        _ = urlComponents?.url
        let task = URLSession.shared.dataTask(with: (urlComponents?.url!)!) { data, _, error in
            guard let jsonData = data else { return }
            do {
                var resultsfields = try JSONDecoder().decode(ConnpassStruct.self, from: jsonData)
                resultsfields.events = resultsfields.events.filter { $0.startedAt > date }
                //https://qiita.com/mafmoff/items/7ffe707c2f3097b44297
                print(resultsfields)
                print(self.resultsfields)
                self.resultsfields.accept(resultsfields.events)
                single(.success(resultsfields.events))

            } catch {
                print(error.localizedDescription)
                single(.error(error))
            }
        }
        task.resume()
        return Disposables.create {
            task.cancel()
        }
    }
  }
}
