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
        
        //TODO: Encode the user object itself as JSON and assign to the body
    postRequest.httpBody = try? JSONEncoder().encode(self)
        
        
        
        //TODO: Create the URLSession task to invoke the request
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            print(String.init(data: data!, encoding: .ascii) ?? "Error")
        }
        task.resume()
    }
    
    // Update this User record using a REST API "PUT"
    func updateServer(withID id:Int){
        //Make not of how url is formed from Api i.e "users/UserID/\(id)"
         let URLstring = DomainURL + "users/\(id)"
         //create an instance of URLRequest passing the urlSring we just created
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
         //now we have our request object we use the httpMethod of the request to set the method - PUT here
        postRequest.httpMethod = "PUT"
        
        //need to send up the data in the body of the request so need the httpBody property of the request
        //passing in self to create the data representation of this instance
        postRequest.httpBody = try? JSONEncoder().encode(self)
        //Now create Task using UrlSession.shared.dataTask passing in the data
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            //now do what we want with data returned
            //the post may return diff depending here we expect a sting message ok sucess
            print(String.init(data: data!, encoding: .ascii) ?? "no data")
            
          }
        task.resume()
        
    }
    
    // Delete this User record using a REST API "DELETE"
    func deleteFromServer(withID id:Int){
        
        let URLstring = DomainURL + "users/\(id)"
               var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
               postRequest.httpMethod = "DELETE"
               
               //TODO: Encode the user object itself as JSON and assign to the body
          // postRequest.httpBody = try? JSONEncoder().encode(self)
               
               
               
               //TODO: Create the URLSession task to invoke the request
               let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
                   print(String.init(data: data!, encoding: .ascii) ?? "Error")
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
        myUser.FirstName = "Juanita"//nil
        myUser.LastName = "A"
        myUser.PhoneNumber = "99988989"
        
        //Test POST method
        myUser.postToServer()
        
        //Test PUT method
        myUser.SID = "123456788"
        myUser.updateServer(withID: 2)
        
        //Test DELETE method
        myUser.deleteFromServer(withID: 2)
        
    }


}

