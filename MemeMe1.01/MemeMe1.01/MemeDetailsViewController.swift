//
//  MemeDetailsViewController.swift
//  MemeMe1.01
//
//  Created by Jamie Pedro on 15/09/2021.
//

import UIKit

// MARK: - MemeDetailsViewController: UIViewController

class MemeDetailsViewController: UIViewController {
    
    // MARK: Properties
    
    var memes: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var detailedImageView: UIImageView!
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedImageView.image = memes.memedImage
        
    
    }
    

}
