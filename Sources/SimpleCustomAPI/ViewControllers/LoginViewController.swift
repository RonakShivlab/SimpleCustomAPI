//
//  LoginViewController.swift
//  
//
//  Created by STL on 06/03/24.
//

import UIKit

public class LoginViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: "cell")
//        self.tableView?.showsVerticalScrollIndicator = false
    }
}


extension LoginViewController: UITableViewDelegate, UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        return cell
    }

}