import RxSwift
import RxCocoa
import UIKit

class ConnpassModel {

    private let disposeBag = DisposeBag()
    let viewController = ViewController()
    var searchBar: UISearchBar!
    var keyword: String!
    let resultsfields = BehaviorRelay<[ConnpassStruct.Events]>(value: [])

    func fetchEvent(keyword) -> Single<[ConnpassStruct.Events]> {
    return Single<[ConnpassStruct.Events]>.create { single in
        let connpassApiUrl = "https://connpass.com/api/v1/event/"
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormater.string(from: Date())
        var urlComponents = URLComponents(string: connpassApiUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "keyword", value: self.keyword)
        ]
        //https://qiita.com/KosukeOhmura/items/8b65bdb63da6df95c7a3
        let url = urlComponents?.url
        let task = URLSession.shared.dataTask(with: (urlComponents?.url!)!) { data, _, error in
            guard let jsonData = data else { return }
            do {
                var resultsfields = try JSONDecoder().decode([ConnpassStruct.Events].self, from: jsonData)
                resultsfields = resultsfields.filter { $0.startedAt > date }
                //https://qiita.com/mafmoff/items/7ffe707c2f3097b44297
                self.resultsfields.accept(resultsfields)

//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
                single(.success(resultsfields))

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
