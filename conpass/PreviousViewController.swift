import UIKit

class PreviousViewController: UIViewController {
    
    var leftBarButton: UIBarButtonItem!
    var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Previous Page"
        
        leftBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(PreviousViewController.NoAction))
        
        rightBarButton = UIBarButtonItem(title: "Top Page >", style: .plain, target: self, action: #selector(PreviousViewController.tappedRightBarButton))
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        self.view.backgroundColor = UIColor.green
    }
    
    // ボタンをタップしたときのアクション
    @objc func tappedRightBarButton() {
        let topPage = ViewController()
        self.navigationController?.pushViewController(topPage, animated: true)
    }
    
    @objc func NoAction(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
