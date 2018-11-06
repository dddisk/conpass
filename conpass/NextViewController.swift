import UIKit

class NextViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height:100))
        backButton.setTitle("back！", for: .normal)
        backButton.backgroundColor = .white
        backButton.addTarget(self, action: #selector(NextViewController.back(_:)), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func back(_ sender: UIButton) {// selectorで呼び出す場合Swift4からは「@objc」をつける。
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
