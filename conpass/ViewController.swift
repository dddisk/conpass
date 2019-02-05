import UIKit
import SafariServices
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    private var tableView = UITableView()
    var baseview = UIView()
    var resultsfields = [ConnpassStruct.Events]()
    var viewModel: ConnpassViewModel!
    var searchBar: UISearchBar!
    var keyword: String!
    //uibarbuttonitemのアイコンの種類　https://fussan-blog.com/swift-uibarbuttonitem/
    var ascButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: nil, action: nil)
    var descButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: nil, action: nil)
    //rxから追加
    private let disposeBag = DisposeBag()
//  起動時にviewDidLoadが呼ばれ、中の処理を走らせる
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        setupSearchBar()

        self.viewModel = ConnpassViewModel(
        searchKeyword: self.searchBar.rx.text.asDriver(),
        ascButton: self.ascButton.rx.tap.asDriver(onErrorDriveWith: Driver.empty()),
        descButton: self.descButton.rx.tap.asDriver(onErrorDriveWith: Driver.empty()),
        //https://github.com/ReactiveX/RxSwift/blob/master/Tests/RxCocoaTests/UISearchBar%2BRxTests.swift
        searchButton: self.searchBar.rx.searchButtonClicked.asDriver()
        )

        self.viewModel.ascButton
            .drive(onNext: { [weak self] in
            self?.resultsfields.sort(by: {$0.startedAt < $1.startedAt})
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)

        self.viewModel.descButton
            .drive(onNext: { [weak self] in
                self?.resultsfields.sort(by: {$1.startedAt < $0.startedAt})
                DispatchQueue.main.async {
                self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)

        self.viewModel.resultsfields
            .asDriver()
            .drive(onNext: { [weak self] resultsfields in
                self?.resultsfields = resultsfields
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
            }).disposed(by: self.disposeBag)

        self.viewModel.searchKeyword
            .drive(self.searchBar.rx.text)
            .disposed(by: disposeBag)
        //https://qiita.com/fumiyasac@github/items/da762ea512484a8291a3
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
    //https://dev.classmethod.jp/smartphone/iphone/incremental-search-using-rxswift-and-rxcocoa/
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
        // キーボードを閉じる
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let resultsfield = resultsfields[indexPath.row]
        cell.textLabel?.text = resultsfield.title
        cell.detailTextLabel?.text = resultsfield.startedAt
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsfields.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultsfield = resultsfields[indexPath.row]
        let webPage = resultsfield.eventUrl
        let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
}
