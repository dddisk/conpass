import UIKit

struct Resultsfield: Codable {
    var events: [Events]
    struct Events: Codable {
        var title: String
        var event_url: String
    }
}

struct Connpass {
    
    static func fetchEvent(completion: @escaping (Resultsfield) -> Swift.Void) {
        
        let url = "https://connpass.com/api/v1/event/?keyword=python"
        
        let urlComponents = URLComponents(string: url)
        let task = URLSession.shared.dataTask(with: (urlComponents?.url!)!) { data, response, error in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let resultsfields = try JSONDecoder().decode(Resultsfield.self, from: jsonData)
                completion(resultsfields)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}


class ViewController: UIViewController {
    
    
    private var tableView = UITableView()
    var resultsfields: Resultsfield = Resultsfield(events: [])

//  起動時にviewDidLoadが呼ばれ、中の処理を走らせる
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "最新記事"
        
        setUpTableView: do {
            tableView.frame = view.frame
            tableView.dataSource = self
            view.addSubview(tableView)
            let nextButton = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height:100))
            nextButton.setTitle("Go!", for: .normal)
            nextButton.backgroundColor = .blue
            nextButton.addTarget(self, action: #selector(ViewController.goNext(_:)), for: .touchUpInside)
            view.addSubview(nextButton)
        }
        
        Connpass.fetchEvent(completion: { (resultsfields) in
            self.resultsfields = resultsfields
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }

    @objc func goNext(_ sender: UIButton) {
        let nextvc = NextViewController()
        nextvc.view.backgroundColor = UIColor.blue
        self.present(nextvc, animated: true, completion: nil)
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
