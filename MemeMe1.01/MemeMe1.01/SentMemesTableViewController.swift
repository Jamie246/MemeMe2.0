//
//  MemeTableViewController.swift
//  MemeMe1.01
//
//  Created by Jamie Pedro on 15/09/2021.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var allMemes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = self.allMemes[(indexPath as NSIndexPath).row]
        
        // set image and title
        cell.cellImageView.image = meme.memedImage
        cell.cellTopTextLabel.text = meme.topText
        cell.cellBottomTextLabel.text = meme.bottomText

        return cell
        
    }
    
    
    // MARK: - Navigation
    
    // Perform Segue for selected cell object
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailController.memes = self.allMemes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)

    }
}

