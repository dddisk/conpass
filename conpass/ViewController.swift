import UIKit
import SafariServices

struct Resultsfield: Codable {
    var events: [Events]
    struct Events: Codable {
        var title: String
        var event_url: String
    }
}

class ViewController: UIViewController {
    
    
    private var tableView = UITableView()
    var resultsfields: Resultsfield = Resultsfield(events: [])
    
    //  起動時にviewDidLoadが呼ばれ、中の処理を走らせる
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        title = "最新記事"
        
        setUpTableView: do {
            tableView.frame = view.frame
            tableView.dataSource = self
            view.addSubview(tableView)
        }
        
        ConnpassModel.fetchEvent(completion: { (resultsfields) in
            self.resultsfields = resultsfields
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
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
