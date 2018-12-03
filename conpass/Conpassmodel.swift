import RxCocoa
import RxSwift
import UIKit

struct ConpassModel {
//    @escapingの意味https://qiita.com/ottijp/items/e45b65263c53037af1ee
//    urlsession 意味https://qiita.com/shiz/items/09523baf7d1cd37f6dee#urlsession%E3%81%A8%E3%81%AF
//    urlcomponents 意味　https://qiita.com/KosukeOhmura/items/8b65bdb63da6df95c7a3
    static func fetchEvent() -> Observable<Resultsfield> {
        return Observable<Resultsfield>.create { observer in
            let url = "https://connpass.com/api/v1/event/?keyword=python"
            let urlComponents = URLComponents(string: url)
            let task = URLSession.shared.dataTask(with: (urlComponents?.url!)!) { data, response, error in
                guard
                    let jsonData = data
                    else { return }
                do {
                    let resultsfields = try JSONDecoder().decode(Resultsfield.self, from: jsonData )
                    observer.onNext(resultsfields)
                } catch {
                    print(error.localizedDescription)
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

