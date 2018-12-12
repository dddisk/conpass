import UIKit
import SafariServices

class ViewController: UIViewController{
    private var tableView = UITableView()
    private var mySystemButton: UIButton!
    var resultsfields: ConnpassViewModel = ConnpassViewModel(events: [])
    var searchBar = UISearchBar()
    
//  起動時にviewDidLoadが呼ばれ、中の処理を走らせる
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        for i in 1...5 {
            var sss:[Int] = []
            sss.append(i)
            print(sss)
        }
        setUpTableView: do {
            tableView.frame = view.frame
            tableView.dataSource = self
            view.addSubview(tableView)
        }

        ConnpassModel.fetchEvent(completion: { (resultsfields) in
            self.resultsfields = resultsfields
            //https://1000ch.net/posts/2016/dispatch-queue.html
            //https://qiita.com/mag4n/items/bcdf1e88794317cf8c9c 古いけど使える
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })

    }
    @objc func buttonEvent(_ sender: UIButton) {
        print("ボタンの情報: \(sender)")
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let resultsfield = resultsfields.events[indexPath.row]
        cell.textLabel?.text = resultsfield.title
        cell.detailTextLabel?.text = resultsfield.started_at
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

extension ViewController: UISearchBarDelegate {
    //https://qiita.com/Simmon/items/8760de60162068781278 参考
    //    http://blue-bear.jp/kb/swift4-tableview%E3%81%ABuisearchbar%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%99%E3%82%8B/
    func searchup(){
        searchBar.delegate = self
        searchBar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:42)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 89)
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "検索"
        searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        tableView.tableHeaderView = searchBar
        print(searchBar.text)
//        //searchBarの位置とサイズを設定
//        searchBar.frame = CGRect(x:((self.view.bounds.width-320)/2),y:300,width:320,height:50)
//        //薄文字の説明
//        searchBar.placeholder = "ここに入力してください"
//        //ViewにsearchBaroをSubViewとして追加
//        self.view.addSubview(searchBar)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        self.tableView.reloadData()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }

}
