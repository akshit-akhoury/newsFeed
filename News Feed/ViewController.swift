//
//  ViewController.swift
//  News Feed
//
//  Created by Akshit Akhoury on 27/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var newsItems: newsFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if(error != nil)
            {
                print(error!)
                return
            }
            guard let data = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let dateDecoder = DateFormatter()
                dateDecoder.dateFormat = "yyyy-mm-dd HH:mm:ss"
                jsonDecoder.dateDecodingStrategy = .formatted(dateDecoder)
                
                self.newsItems = try jsonDecoder.decode(newsFeed.self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error
            {
                print(error)
                print("Exception while trying to create JSON")
            }
        }.resume()
    }
}

extension ViewController:UITableViewDelegate{
    
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatDisplay = DateFormatter()
        dateFormatDisplay.dateFormat = "MMM dd, yyyy hh:mm a"
        guard let newsCell = newsItems?.items?[indexPath.row] else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalNewsCell",for: indexPath)
            return cell
        }
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "highlightedCell",for: indexPath) as! ProminentTableViewCell
            cell.titleLabel.text = newsCell.title
            cell.dateLabel.text = dateFormatDisplay.string(from:newsCell.date!)
            cell.customImageView.loadImageFromURLString(urlString: newsCell.enclosure.link)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 15.0
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalNewsCell",for: indexPath) as! RegularNewsTableViewCell
            cell.titleLabel.text = newsCell.title
            cell.dateLabel.text = dateFormatDisplay.string(from:newsCell.date!)
            cell.customImageView.loadImageFromURLString(urlString: newsCell.thumbNailURL!)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 15.0
            return cell
        }
    }
}

extension UIImageView {
    func loadImageFromURLString(urlString:String) {
        var url = URL(string: urlString)
        var urlComp = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        urlComp?.query = nil
        url = urlComp?.url
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if(error != nil)
            {
                print(error)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
