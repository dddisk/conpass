//
//  TableViewController.swift
//  conpass
//
//  Created by shiroma_daisuke on 2018/11/01.
//  Copyright © 2018年 shiroma_daisuke. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIButton(frame: CGRect(x: 0,y: 0,width: 100,height:100))
        backButton.setTitle("back！", for: .normal)
        backButton.backgroundColor = UIColor.white
        backButton.addTarget(self, action: #selector(TableViewController.back(_:)), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func back(_ sender: UIButton) {// selectorで呼び出す場合Swift4からは「@objc」をつける。
        self.dismiss(animated: true, completion: nil)
    }

}
