import UIKit
import SafariServices

class ViewController: UIViewController {
    private var tableView = UITableView()
    var baseview = UIView()
    var resultsfields: ConnpassViewModel = ConnpassViewModel(events: [])
    var searchBar: UISearchBar!
    var keyword: String!
//  起動時にviewDidLoadが呼ばれ、中の処理を走らせる
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        tableView.delegate = self
        baseview.frame = view.frame
        baseview.backgroundColor = UIColor.red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //場所を変えると表示されない？？
        tableView.dataSource = self
        view.addSubview(baseview)
        view.addSubview(tableView)
        let AscButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(AscButtonTapped(sender:)))
        let DescButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(DescButtonTapped(sender:)))
        self.navigationItem.setRightBarButtonItems([AscButton, DescButton], animated: true)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0).isActive = true
    }
    @objc func AscButtonTapped(sender: UIButton) {
        if resultsfields.events.isEmpty {
            print("no asc data")
        } else {
            resultsfields.events.sort(by: {$0.startedAt < $1.startedAt})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc func DescButtonTapped(sender: UIButton) {
        if resultsfields.events.isEmpty {
            print("no desc data")
        } else {
            resultsfields.events.sort(by: {$1.startedAt < $0.startedAt})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "URLまたは検索ワード"
            // UINavigationBar上に、UISearchBarを追加
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // ソフトウェアキーボードの検索ボタンが押された
        searchurl(urlString: searchBar.text!)
        // キーボードを閉じる
        searchBar.resignFirstResponder()
    }
    func searchurl(urlString: String) {
        self.keyword = urlString
        fetchEvent(completion: { (resultsfields) in
            self.resultsfields = resultsfields
            //https://qiita.com/narukun/items/b1b6ec856aee42767694
            //https://1000ch.net/posts/2016/dispatch-queue.html
            //https://qiita.com/mag4n/items/bcdf1e88794317cf8c9c 古いけど使える
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    func fetchEvent(completion: @escaping (ConnpassViewModel) -> Swift.Void) {
        let connpassApiUrl = "https://connpass.com/api/v1/event/"
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormater.string(from: Date())
        var urlComponents = URLComponents(string: connpassApiUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "keyword", value: keyword)
        ]
        //https://qiita.com/KosukeOhmura/items/8b65bdb63da6df95c7a3
        let url = urlComponents?.url
        let task = URLSession.shared.dataTask(with: (urlComponents?.url!)!) { data, _, error in
            guard let jsonData = data else {
                return
            }
            do {
                var resultsfields = try JSONDecoder().decode(ConnpassViewModel.self, from: jsonData)
                resultsfields.events = resultsfields.events.filter { $0.startedAt > date }
                completion(resultsfields)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let resultsfield = resultsfields.events[indexPath.row]
        cell.textLabel?.text = resultsfield.title
        cell.detailTextLabel?.text = resultsfield.startedAt
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsfields.events.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultsfield = resultsfields.events[indexPath.row]
        let webPage = resultsfield.eventUrl
        let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
}
