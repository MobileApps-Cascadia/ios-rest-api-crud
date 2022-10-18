//
//  ViewController.swift
//  ios-rest-api
//
//  Created by Brian Bansenauer on 9/25/19.
//  Copyright © 2019 Cascadia College. All rights reserved.
//

import UIKit

let DomainURL = "https://mikethetall.pythonanywhere.com/"
    
class User: Codable {
    var UserID: String?
    var FirstName: String?
    var LastName: String?
    var PhoneNumber: String?
    var SID: String?
    
    // Read an User record from the server
    static func fetch(withID id:Int){
            let URLstring = DomainURL + "users/\(String(id))"
            if let url = URL.init(string: URLstring){
                let task = URLSession.shared.dataTask(with: url, completionHandler:
                {(dataFromAPI, response, error) in
                    print(String.init(data:dataFromAPI!, encoding: .ascii) ?? "no data")
                    if let myUser = try? JSONDecoder().decode(User.self, from:  dataFromAPI!){
                        print(myUser.FirstName ?? "No name")
                    }
                })
                task.resume()
            }
    }
    // Create a new User record using a REST API "POST"
    func postToServer(){
        let URLstring = DomainURL + "users"
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "POST"
        
        //TODO: Encode the user object itself as JSON and assign to the body
        postRequest.httpBody = try? JSONEncoder().encode(self)
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //TODO: Create the URLSession task to invoke the request
        let task = URLSession.shared.dataTask(with: postRequest) {
            (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }
    
    // Update this User record using a REST API "PUT"
    func updateServer(withID id:Int){
        
    }
    
    // Delete this User record using a REST API "DELETE"
    func deleteFromServer(withID id:Int){
        let URLstring = DomainURL + "users/\(String(id))"
               var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
               postRequest.httpMethod = "DELETE"

               let task = URLSession.shared.dataTask(with: postRequest) {
                   (data, response, error) in
                    print(String.init(data: data!, encoding: .ascii) ?? "no data")
               }
               task.resume()
        
    }
}



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        User.fetch(withID: 1)
        
        //TODO: Assign values to this User object properties
        let myUser = User()
        myUser.FirstName = "Ali"
        myUser.LastName = "Ababwa"
        myUser.PhoneNumber = "2062062206"
        
        //Test POST method
        //myUser.postToServer()
        
        //Test PUT method
        //myUser.SID = "123456789"
        //myUser.updateServer(withID: <#T##Int#>)
        
        //Test DELETE method
        myUser.deleteFromServer(withID: 5)
        
    }


}

