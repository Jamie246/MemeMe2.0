//
//  ViewController.swift
//  MemeMe1.01
//
//  Created by Jamie Pedro on 20/08/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var toolbars: [UIToolbar]!
    
    var AllMemes: Meme?
    
    
    // MARK: set initial text on top and bottom text fields
    
    let topDefaultFieldText: String = "TOP"
    let bottomDefaultFieldText: String = "BOTTOM"
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSAttributedString.Key.strokeWidth: -3.0
    ]


    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = memeTextAttributes
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shareButton.isEnabled = false
        setupTextField(tf: topTextField, text: topDefaultFieldText)
        topTextField.delegate = self
        setupTextField(tf: bottomTextField, text: bottomDefaultFieldText)
        bottomTextField.delegate = self
        

        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        //Device has a camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Image Picker functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        imagePickerView.image = image
        }
        
        
        //enables share button once user selects photo
        shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    

    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }

    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    

    // MARK: Text field functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTextField.text == "TOP"  && textField == topTextField {
            topTextField.text = ""
        }
        if bottomTextField.text == "BOTTOM" && textField == bottomTextField {
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder, view.frame.origin.y == 0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    
    // create a meme object and save it to the memes array
    func save() {
        
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Sharing Meme

    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        toolbars.forEach {
            $0.isHidden = true
        }
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbars.forEach {
            $0.isHidden = false
        }
        
        return memedImage
        
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true}
        
        // Generate a memed imaged
        let memedImage = generateMemedImage()
        
        //Defines an instance of activityViewController
        //And then passes the ActivityViewController a memedImage as an activity item
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Presents the ActivityViewController
        present(activityViewController, animated: true, completion: nil)
        
        // Saves the meme using completionWithItemsHandler
        activityViewController.completionWithItemsHandler = {
            activity, completed, items, error in if completed {
                _ = (topText: self.topTextField.text! as NSString?, bottomText: self.bottomTextField.text! as NSString?, image: self.imagePickerView.image, memedImage: memedImage)
                
                // Dismisses the ActivityViewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    @IBAction func discardMeme(_ sender: Any) {
        shareButton.isEnabled = false
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    


    

}



