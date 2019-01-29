import UIKit
import SafariServices
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    private var tableView = UITableView()
    var baseview = UIView()
    var resultsfields: ConnpassStruct = ConnpassStruct(events: [])
    var searchBar: UISearchBar!
    var keyword: String!
    var viewModel: ConnpassViewModel = ConnpassViewModel()
    //uibarbuttonitemのアイコンの種類　https://fussan-blog.com/swift-uibarbuttonitem/
    var ascButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: nil, action: nil)
    var descButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: nil, action: nil)
    //rxから追加
    private let disposeBag = DisposeBag()
//  起動時にviewDidLoadが呼ばれ、中の処理を走らせる
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableview()

        let input = ConnpassViewModelInput (
            //https://qiita.com/k5n/items/44ef2ab400f47fb66731
            ascButton: ascButton.rx.tap.asDriver(onErrorDriveWith: Driver.empty()),
            descButton: descButton.rx.tap.asDriver(onErrorDriveWith: Driver.empty())
        )
        viewModel.setup(input: input)
        input.ascButton.drive(onNext: { [weak self] in
            print("test2")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
            .disposed(by: disposeBag)

        input.descButton.drive(onNext: { [weak self] in
            DispatchQueue.main.async {
            self?.tableView.reloadData()
            }
        })
            .disposed(by: disposeBag)
    }

    func setupTableview() {
        tableView.delegate = self
        baseview.frame = view.frame
        baseview.backgroundColor = UIColor.red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //場所を変えると表示されない？？
        tableView.dataSource = self
        view.addSubview(baseview)
        view.addSubview(tableView)
        self.navigationItem.setRightBarButtonItems([ascButton, descButton], animated: true)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0).isActive = true

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
        ConnpassModel.fetchEvent(searchText: self.keyword)
//        ConnpassModel.fetchEvent()
        //            self.resultsfields = resultsfields
        //https://qiita.com/narukun/items/b1b6ec856aee42767694
        //https://1000ch.net/posts/2016/dispatch-queue.html
        //https://qiita.com/mag4n/items/bcdf1e88794317cf8c9c 古いけど使える
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
