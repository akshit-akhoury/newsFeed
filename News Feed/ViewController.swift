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
        self.title = "Hey"
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
