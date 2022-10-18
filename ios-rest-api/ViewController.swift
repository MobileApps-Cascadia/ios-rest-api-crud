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
    static func fetch(withID id:Int, completionHandler: @escaping (User)->Void){
        let URLstring = DomainURL + "users/\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
                                                    {(dataFromAPI, response, error) in
                print(String.init(data:dataFromAPI!, encoding: .ascii) ?? "no data")
                if let myUser = try? JSONDecoder().decode(User.self, from:  dataFromAPI!){
                    print(myUser.FirstName ?? "No name")
                    completionHandler(myUser)
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
    //        print(String(data: postRequest.httpBody!, encoding: .utf8)!)
            //TODO: Create the URLSession task to invoke the request
            let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")
                if
                    error == nil,
                                        let httpResponse = response as? HTTPURLResponse
                                    {
                                        switch httpResponse.statusCode {
                                        case 204:
                                            print("it worked")
                                            break
                                        //...
                                        default:
                                            break
                                        }
                                    } else {
                                        //error case here...
                                    }
                            }
                            task.resume()
                        }
    
    
    func updateServer(withID id:Int){
        guard self.SID != nil else {return}
        let URLstring = DomainURL + "users/id/\(self.SID!)"
        var req = URLRequest.init(url: URL.init(string: URLstring)!)
        req.httpMethod = "PUT"
        
        req.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in print (String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }
    
    
    
    
    // Delete this User record using a REST API "DELETE"
    func deleteFromServer(withID id:Int){
        guard self.SID != nil else {return}
        let URLstring = DomainURL + "users/id/\(self.SID!)"
        var req = URLRequest.init(url: URL.init(string: URLstring)!)
        req.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in print (String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
        
    }
    
    
    
    
    class ViewController: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            User.fetch(withID: 2) { (myUser) in
                print (myUser.FirstName ?? "no name")
                myUser.FirstName = "new name"
                myUser.deleteFromServer(withID: 123456789)
                //myUser.updateServer()
                //if let myUser = try? JSONEncoder().encode(myUser) {
                // print (myUser)
                
                
                
                //TODO: Assign values to this User object properties
                let myUser = User()
                myUser.FirstName = nil
                myUser.LastName = nil
                myUser.PhoneNumber = nil
                
                //Test POST method
                myUser.postToServer()
                
                //Test PUT method2
                myUser.SID = "123456789"
                myUser.updateServer(withID: 123456789)
                
                //Test DELETE method
                myUser.deleteFromServer(withID: 123456789)
                
            }
        }
        
        
    }
}
