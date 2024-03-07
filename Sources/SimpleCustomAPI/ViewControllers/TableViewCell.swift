//
//  TableViewCell.swift
//  
//
//  Created by STL on 06/03/24.
//

import UIKit

struct loginRequest: Encodable{
    let username: String
    let password: String
}

struct loginReponse: Decodable{
    let token: String
    let username: String
}

public class TableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var tfEmailAddress: CustomTextField!
    @IBOutlet weak var tfPassword: CustomTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var appLogo: UIImageView!
    private let apiClient = GenericAPIClient<loginReponse>(baseURL: URL(string: "https://dummyjson.com/auth/")!)
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tfEmailAddress.delegate = self
        tfPassword.delegate = self
//        let loginRequest = loginRequest(username: "kminchelle", password: "0lelplR")
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
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
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}
