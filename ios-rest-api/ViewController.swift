//
//  ViewController.swift
//  ios-rest-api
//
//  Created by Brian Bansenauer on 9/25/19.
//  Copyright © 2019 Cascadia College. All rights reserved.
//

import UIKit

let DomainURL = "https://www.orangevalleycaa.org/api/"

class Music : Codable{
    var id : String?
    var music_url : String?
    var name : String?
    var description : String?
    
    static func fetch(withID id : Int, completionHandler: @escaping (Music)->Void){
        let urlString = DomainURL + "music/id/\(id)"
        
        if let url = URL.init(string: urlString){
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")
                if let newMusic = try? JSONDecoder().decode(Music.self, from: data!) {
                    print (newMusic.music_url ?? "no url")
                    completionHandler(newMusic)
                }
            })
            task.resume()
        }
    }
    func postToServer(){
        let urlString = DomainURL + "music/"
        var postRequest = URLRequest.init(url: URL.init(string: urlString)!)
        postRequest.httpMethod = "POST"
        postRequest.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data :/")
        }
        task.resume()
    }
    func updateServer(){
        guard self.id != nil else {return}
        let urlString = DomainURL + "music/id/\(self.id!)"
        var postRequest = URLRequest.init(url: URL.init(string: urlString)!)
        postRequest.httpMethod = "PUT"
        postRequest.httpBody = try? JSONEncoder().encode(self)
        
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data :/")
        }
        task.resume()
    }
    func deleteFromServer(){
        guard self.id != nil else {return}
        let urlString = DomainURL + "music/id/\(self.id!)"
        var postRequest = URLRequest.init(url: URL.init(string: urlString)!)
        postRequest.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            print (String.init(data: data!, encoding: .ascii) ?? "no data :/")
        }
        task.resume()
    }
}

class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Music.fetch(withID: 1) { (newMusic) in
            print(newMusic.music_url ?? "no url")
            //newMusic.postToServer() //POST
            //newMusic.updateServer() //UPDATE
            newMusic.deleteFromServer() //DELETE
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
