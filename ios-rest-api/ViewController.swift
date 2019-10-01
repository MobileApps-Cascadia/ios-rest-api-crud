//
//  ViewController.swift
//  ios-rest-api
//
//  Created by Brian Bansenauer on 9/25/19.
//  Copyright © 2019 Cascadia College. All rights reserved.
//

import UIKit

    let DomainURL = "http://216.186.69.45/services/device/"
    
class User: Codable {
    var UserID: String?
    var FirstName: String?
    var LastName: String?
    var PhoneNumber: String?
    var SID: String?
    
    // Read an User record from the server
    static func fetch(withID id:Int){
            let URLstring = DomainURL + "users/\(id)"
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
        let URLstring = DomainURL + "users/"
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "POST"
        postRequest.httpBody = try? JSONEncoder().encode(self);
        //TODO: Encode the user object itself as JSON and assign to the body
        
        let task = URLSession.shared.dataTask(with: postRequest) { (info, response, error) in
            print(String.init(data: info!, encoding: .ascii) ?? "oops")
        }
        //TODO: Create the URLSession task to invoke the request
        task.resume()
    }
    
    // Update this User record using a REST API "PUT"
    func updateServer(withID id:Int){
        let URLstring = DomainURL + "users/\(id)"
        var putRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        putRequest.httpMethod = "PUT"
        putRequest.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: putRequest) { (info, response, error) in
            print(String.init(data: info!, encoding: .ascii) ?? "oops")
        }
        
        task.resume()
    }
    
    // Delete this User record using a REST API "DELETE"
    func deleteFromServer(withID id:Int){
        
        let URLstring = DomainURL + "users/\(id)"
        var DeleteRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        DeleteRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: DeleteRequest) { (info, response, error) in
            print(String.init(data: info!, encoding: .ascii) ?? "oops")
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
        User.fetch(withID: 2)
        
        //TODO: Assign values to this User object properties
        let myUser = User()
        myUser.FirstName = "robert"
        myUser.LastName = "ramirez"
        myUser.PhoneNumber = "4257803217"
        
        //Test POST method
        myUser.postToServer()
        
        //Test PUT method
        myUser.SID = "123456789"
        myUser.updateServer(withID: 2)
        
        //Test DELETE method
        myUser.deleteFromServer(withID: 34)
        
    }


}

