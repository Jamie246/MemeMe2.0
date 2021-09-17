//
//  MemeCollectionViewController.swift
//  MemeMe1.01
//
//  Created by Jamie Pedro on 15/09/2021.
//

import UIKit

private let reuseIdentifier = "CollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var allMemes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 4.0
        let dimension = (view.frame.size.width - (3 * space)) / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView!.reloadData()

    }
    

    
    // MARK: Collection View Data Source
    
    // Return number of rows for table
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    // Provide a cell object for each row
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Fetch a cell of the appropriate type
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = self.allMemes[(indexPath as NSIndexPath).row]
        cell.collectionImageView!.image = meme.memedImage
        
        return cell
        
    }
    
    // Send for Segue from selected Item
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailController.memes = self.allMemes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
    }

        

}
