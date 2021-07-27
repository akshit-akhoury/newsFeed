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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.title = "Hey"
        fetchFromServer()
    }
    
    @objc private func refreshData()
    {
        fetchFromServer()
    }
    func fetchFromServer()
    {
        newsItems = newsFeed()
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
                    self.tableView.refreshControl?.endRefreshing()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0)
        {
            return 300
        }
        else
        {
            return 150
        }
    }
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
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalNewsCell",for: indexPath) as! RegularNewsTableViewCell
            cell.titleLabel.text = newsCell.title
            cell.dateLabel.text = dateFormatDisplay.string(from:newsCell.date!)
            cell.customImageView.loadImageFromURLString(urlString: newsCell.thumbNailURL!)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cellLayer = CALayer()
        cellLayer.cornerRadius = 15
        cellLayer.backgroundColor = UIColor.gray.cgColor
        cellLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 5, dy: 5)
        cell.layer.mask = cellLayer
    }
}
