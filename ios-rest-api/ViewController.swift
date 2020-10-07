//
//  ViewController.swift
//  ios-rest-api
//
//  Created by Brian Bansenauer on 9/25/19.
//  Copyright © 2019 Cascadia College. All rights reserved.
//

import UIKit

    let DomainURL = "https://www.orangevalleycaa.org/api/"
    
class Music: Codable {
    
    var id: String?
    var music_url: String?
    var name: String?
    var description: String?
    
    // Read an Music record from the server
    static func fetch(withID id:Int, completionHandler: @escaping (Music)->Void) {
            let URLstring = DomainURL + "music/id/\(id)"
        
            if let url = URL.init(string: URLstring){
                let task = URLSession.shared.dataTask(with: url, completionHandler:
                {(dataFromAPI, response, error) in
                    print(String.init(data:dataFromAPI!, encoding: .ascii) ?? "no data")
                    if let newMusic = try? JSONDecoder().decode(Music.self, from:  dataFromAPI!){
                        print(newMusic.id ?? "no id")
                        print(newMusic.music_url ?? "no url")
                        completionHandler(newMusic)
                    }
                })
                task.resume()
            }
    }
    // Create a new User record using a REST API "POST"
    func postToServer(){
        let URLstring = DomainURL + "music/"
        
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "POST"
        
        //TODO: Encode the user object itself as JSON and assign to the body
        postRequest.httpBody = try? JSONEncoder().encode(self)
        
        //TODO: Create the URLSession task to invoke the request
        let task = URLSession.shared.dataTask(with: postRequest) { (dataFromAPI, response, error) in
            print(String.init(data: dataFromAPI!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }
    
    // Update this User record using a REST API "PUT"
    func updateServer(withID id:Int){
        guard self.id != nil else {return}
        let URLstring = DomainURL + "music/id/\(self.id!)"
        
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "PUT"
        postRequest.httpBody = try? JSONEncoder().encode(self)
        
        //TODO: Create the URLSession task to invoke the request
        let task = URLSession.shared.dataTask(with: postRequest) { (dataFromAPI, response, error) in
            print(String.init(data: dataFromAPI!, encoding: .ascii) ?? "no data")
        }
        task.resume()
        
    }
    
    // Delete this User record using a REST API "DELETE"
    func deleteFromServer(withID id:Int){
        guard self.id != nil else {return}
        let URLstring = DomainURL + "music/id/\(self.id!)"
        
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "DELETE"
        
        //TODO: Create the URLSession task to invoke the request
        let task = URLSession.shared.dataTask(with: postRequest) { (dataFromAPI, response, error) in
            print(String.init(data: dataFromAPI!, encoding: .ascii) ?? "no data")
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
        Music.fetch(withID: 2) { (newMusic) in
            print(newMusic.music_url ?? "no url")
            newMusic.postToServer()
        }
        
        //TODO: Assign values to this User object properties
        let myMusic = Music()
        myMusic.name = "NSYNC"
        myMusic.description = "pop"
        myMusic.music_url = nil
        
        //Test POST method
        myMusic.postToServer()
        
        //Test PUT method
        myMusic.id = "2"
        myMusic.updateServer(withID: 1)
        
        //Test DELETE method
        myMusic.deleteFromServer(withID: 1)
        
    }


}

