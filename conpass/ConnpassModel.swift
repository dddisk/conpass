import UIKit

struct ConnpassModel {
    //@escapingの概要 https://qiita.com/ottijp/items/e45b65263c53037af1ee
    //voidは戻り値がないという意味
    static func fetchEvent(completion: @escaping (ConnpassViewModel) -> Swift.Void) {
        
        let url = "https://connpass.com/api/v1/event/"
        
        let urlComponents = URLComponents(string: url)
        let task = URLSession.shared.dataTask(with: (urlComponents?.url!)!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let resultsfields = try JSONDecoder().decode(ConnpassViewModel.self, from: jsonData)
                completion(resultsfields)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

