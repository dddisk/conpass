import UIKit
import SafariServices

class ViewController: UIViewController{
    private var tableView = UITableView()
    private var mySystemButton: UIButton!
    var resultsfields: ConnpassViewModel = ConnpassViewModel(events: [])
    var searchBar: UISearchBar!
//  起動時にviewDidLoadが呼ばれ、中の処理を走らせる
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ss")
        setupSearchBar()
        tableView.delegate = self
        tableView.frame = view.frame
        //場所を変えると表示されない？？
        tableView.dataSource = self
        view.addSubview(tableView)

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
        search(urlString: searchBar.text!)
        // キーボードを閉じる
        searchBar.resignFirstResponder()
    }
    
    func search(urlString:String )
    {
        var urlString = urlString
        ConnpassModel.fetchEvent(completion: { (resultsfields) in
            self.resultsfields = resultsfields
            //https://1000ch.net/posts/2016/dispatch-queue.html
            //https://qiita.com/mag4n/items/bcdf1e88794317cf8c9c 古いけど使える
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        print(urlString)
    }
}


extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let resultsfield = resultsfields.events[indexPath.row]
        cell.textLabel?.text = resultsfield.title
        cell.detailTextLabel?.text = resultsfield.event_url
        return cell
    }
    
    func sort() {
        var  sss:[ConnpassViewModel.Events] = []
        for i in resultsfields.events[0...9] {
            sss.append(i)
        }
        sss.sort(by: {$1.started_at < $0.started_at})
        var ssss:[ConnpassViewModel.Events] = sss
        print(ssss)
        ssss.sort(by: {$0.started_at < $1.started_at})
        print(ssss)
        for i in 1...5 {
            var sss:[Int] = []
            sss.append(i)
            print(sss)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsfields.events.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultsfield = resultsfields.events[indexPath.row]
        let webPage = resultsfield.event_url
        let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
}
