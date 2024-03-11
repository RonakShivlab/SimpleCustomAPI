//
//  LoginViewController.swift
//  
//
//  Created by STL on 06/03/24.
//

import UIKit

public protocol LoginViewControllerDelegate: AnyObject{
    func didRecieveApiResponse(response: loginReponse)
}

public class LoginViewController: UIViewController, UITextFieldDelegate {

//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var tfEmailAddress: CustomTextField!
    @IBOutlet weak var tfPassword: CustomTextField!
    @IBOutlet weak var btnLogin: UIButton!
    public static let storyboardVC = UIStoryboard(name: "main", bundle: Bundle.module).instantiateInitialViewController()!
    private let apiClient = GenericAPIClient<loginReponse>(baseURL: URL(string: "https://dummyjson.com/auth/")!)
    public weak var delegate: LoginViewControllerDelegate?
    public override func viewDidLoad() {
        super.viewDidLoad()
//        let nib = UINib(nibName: "TableViewCell", bundle: Bundle.module)
//        let nib = Bundle.module.loadNibNamed("TableViewCell", owner: self)?.first as! UINib
//        self.tableView?.register(nib, forCellReuseIdentifier: "TableViewCell")
//        self.tableView?.register(UINib(nibName: "TableViewCell", bundle: Bundle(for: LoginViewController.self)), forCellReuseIdentifier: "TableViewCell")
//        self.tableView?.showsVerticalScrollIndicator = false
        self.tfEmailAddress.delegate = self
        self.tfPassword.delegate = self
        print("Done")
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        if !tfEmailAddress.validateEmail() {
            tfEmailAddress.text = "Please enter a valid email address."
        } else if !tfPassword.validatePassword() {
            tfPassword.text = "Please enter a valid password."
        } else if (tfEmailAddress.text == "kminchelle") && (tfPassword.text == "0lelplR"){
            print("Success")
            let loginRequest = loginRequest(username: tfEmailAddress.text ?? "", password: tfPassword.text ?? "")
            self.callAPI(with: loginRequest)
        }else{
            print("username and password wrong")
        }
    }
    func callAPI(with requestBody: loginRequest){
        let postData = try? JSONEncoder().encode(requestBody)
        print(postData as Any)
        apiClient.callAPI(endpoint: "login", method: "POST", body: requestBody) { [self] result in
            switch result{
            case .success(let response):
                print("Token: \(response.token)")
                print("Response: \(response)")
                self.delegate?.didRecieveApiResponse(response: response)
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}


//extension LoginViewController: UITableViewDelegate, UITableViewDataSource{
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
////        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//        return cell
//    }
//
//}
