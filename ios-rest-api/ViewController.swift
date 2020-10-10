//
//  ViewController.swift
//  ios-rest-api
//
//  Created by Brian Bansenauer on 9/25/19.
//  Copyright © 2019 Cascadia College. All rights reserved.
//

import UIKit

    let DomainURL = "https://www.orangevalleycaa.org/"
    
class Music: Codable {
    var id: String?
    var music_url: String?
    var name: String?
    var description: String?
    
    // Read an User record from the server
    static func fetch(withID id: Int, completionHandler: @escaping (Music) -> Void) {
            let URLstring = DomainURL + "music/id/\(id)"
            if let url = URL.init(string: URLstring){
                let task = URLSession.shared.dataTask(with: url, completionHandler:
                {(dataFromAPI, response, error) in
                    print(String.init(data:dataFromAPI!, encoding: .ascii) ?? "no data")
                    if let newMusic = try? JSONDecoder().decode(Music.self, from:  dataFromAPI!){
                        print(newMusic.name ?? "No name")
                        print(newMusic.music_url ?? "No url")
                        print(newMusic.description ?? "No desc")
                        completionHandler(newMusic)
                    }
                })
                task.resume()
            }
    }
    // Create a new User record using a REST API "POST"
    func saveToServer(){
        let URLstring = DomainURL + "music/"
        var postRequest = URLRequest.init(url: URL.init(string: URLstring)!)
        postRequest.httpMethod = "POST"
        postRequest.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: postRequest) { data, response, error in
            print(String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        
        task.resume()
    }
    
    // Update this User record using a REST API "PUT"
    func updateServer(){
        guard self.id != nil else {return}
        let urlString = DomainURL + "/music/id/\(self.id!)"
        
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "PUT"
        req.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            print(String.init(data: data!, encoding: .ascii) ?? "no data")
        }
        task.resume()
    }
    
    // Delete this User record using a REST API "DELETE"
    func deleteFromServer(){
        guard self.id != nil else {return}
        let urlString = DomainURL + "/music/id/\(self.id!)"
        
        var req = URLRequest.init(url: URL.init(string: urlString)!)
        req.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
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
    
    override func viewDidAppear(_ animated: Bool) {
        Music.fetch(withID: 2) { newMusic in
            print(newMusic.music_url ?? "no url")
//            newMusic.saveToServer()
//            newMusic.updateServer()
            newMusic.deleteFromServer()
        }
        
    }


}

