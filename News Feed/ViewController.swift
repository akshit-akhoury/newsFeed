//
//  ViewController.swift
//  News Feed
//
//  Created by Akshit Akhoury on 27/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
        tableView.allowsSelection = false
        self.title = "Hey"
        fetchFromServer()
    }
    
    func fetchFromServer()
    {
        let url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=http://www.abc.net.au/news/feed/51120/rss.xml")
        print(url!)
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if(error != nil)
            {
                print(error!)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let dict = json as! [String:AnyObject]
                for newsFeed in dict["items"] as! [Dictionary<String, Any>]
                {
                    //TODO: Parse out as class to be processed later
                    print(newsFeed["title"])
                    print(newsFeed["description"])
                }
                
            }
            catch
            {
                print("Exception while trying to create JSON")
            }
        }.resume()
    }
}

extension ViewController:UITableViewDelegate{
    
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "highlightedCell",for: indexPath)
            cell.textLabel?.text = "Highlighted"
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 25.0
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalNewsCell",for: indexPath)
            cell.textLabel?.text = "Normal"
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 25.0
            return cell
        }
    }
}
