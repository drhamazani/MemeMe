//
//  ViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 06/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Declaring IBOutlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    var topTextFieldEdited = false
    var bottomTextFieldEdited = false
    
    // MARK: Text Attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth:  -3

    ]
    
    // MARK: Declare
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == topTextField {
            topTextFieldEdited = true
        } else if textField == bottomTextField {
            bottomTextFieldEdited = true
        }
    }
    
    // MARK: Declaring textFieldDidBeginEditing Function
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField && topTextFieldEdited == false  {
            textField.text = ""
        } else if textField == bottomTextField && bottomTextFieldEdited == false {
            textField.text = ""
        }
    }
    
    // MARK: Declaring textFieldShouldReturn Function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: Declareing textAttribute Function
    func textAttribute(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = textField == topTextField ? "TOP" : "BOTTOM"
    }
    
    
    // MARK: Declaring viewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.delegate = self
        bottomTextField.delegate = self
        imagePickerView.backgroundColor = .black
        shareButton.isEnabled = false
        textAttribute(textField: topTextField)
        textAttribute(textField: bottomTextField)
    }
    
    // MARK: Declaring viewWillAppear Function
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    // MARK: Declaring viewWillDisappear Function
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Declaring subscribeToKeyboardNotifications Function
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

    }
    
    // MARK: Declaring unsubscribeFromKeyboardNotifications Function
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Declaring keyboardWillShow Function
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // MARK: Declaring keyboardWillHide Function
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    // MARK: Declaring getKeyboardHeight Function
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Declare chooseImageFrom Function
    func chooseImageFrom(source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Declaring imagePickerController Function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: Declaring imagePickerControllerDidCancel Function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: The IBAction for the pick button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        chooseImageFrom(source: .photoLibrary)
    }
    
    // MARK: The IBAction for the camera button
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        chooseImageFrom(source: .camera)
    }
    
    // MARK: The IBAction for opening the activity view
    @IBAction func shareButtonTapped(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            
            if success {
                self.save()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextFieldEdited = false
        bottomTextFieldEdited = false
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    
    // MARK: Declaring generateMemedImage Function
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: Declaring save Function
    func save() {
        // Create the meme
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    

}
