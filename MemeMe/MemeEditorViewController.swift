//
//  ViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 06/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Declaring IBOutlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textEditButton: UIBarButtonItem!
    @IBOutlet weak var backgoundColorButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var textEditPickerView: UIPickerView!
    @IBOutlet weak var backgroundColorPickerView: UIPickerView!
    @IBOutlet weak var pickerViewToolBar: UIToolbar!
    @IBOutlet weak var textSizeSlider: UISlider!
    @IBOutlet weak var textSizeLabelButton: UIBarButtonItem!
    var topTextFieldEdited = false
    var bottomTextFieldEdited = false
    var meme: Meme!
    var pickerViewContent = ""
    var textEditRows = ["font1", "font2"]
    var backgroundColorRows = ["black", "white", "red", "blue", "green", "gray"]
    var backgroundColorPickerViewTapped: [UIColor] = [.black, .white, .red, .blue, .green, .gray]
    
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
        if meme != nil {
            textField.text = textField == topTextField ? meme.topText : meme.bottomText
        } else {
            textField.text = textField == topTextField ? "TOP" : "BOTTOM"
        }
    }
    
    
    // MARK: Declaring viewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.delegate = self
        bottomTextField.delegate = self
        textEditPickerView.delegate = self
        textEditPickerView.dataSource = self
        backgroundColorPickerView.delegate = self
        backgroundColorPickerView.dataSource = self
        imagePickerView.backgroundColor = .black
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.clipsToBounds = true
        if meme != nil {
            imagePickerView.image = meme.originalImage
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
        textAttribute(textField: topTextField)
        textAttribute(textField: bottomTextField)
        navBar.alpha = 0.8
        toolBar.alpha = 0.8
        textEditPickerView.alpha = 0.8
        backgroundColorPickerView.alpha = 0.8
    }
    
    // MARK: Declaring viewWillAppear Function
    override func viewWillAppear(_ animated: Bool) {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        imagePickerView.isUserInteractionEnabled = true
        imagePickerView.addGestureRecognizer(singleTap)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        textEditPickerView.isHidden = true
        backgroundColorPickerView.isHidden = true
        pickerViewToolBar.isHidden = true
    }
    
    // MARK: Declaring viewWillDisappear Function
    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.navigationBar.isHidden = false
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == textEditPickerView {
            return textEditRows.count
        } else if pickerView == backgroundColorPickerView {
            return backgroundColorRows.count
        } else {
            return 1
        }
//        if self.pickerViewContent == "textEdit" {
//            return textEditRows.count
//        } else if self.pickerViewContent == "backgroundColor" {
//            return backgroundColorRows.count
//        } else {
//            return 1
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == textEditPickerView {
            return textEditRows[row]
        } else if pickerView == backgroundColorPickerView {
            return backgroundColorRows[row]
        } else {
            return "Empty"
        }
//        if self.pickerViewContent == "textEdit" {
//            return textEditRows[row]
//        } else if self.pickerViewContent == "backgroundColor" {
//            return backgroundColorRows[row]
//        } else {
//            return "Empty"
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == textEditPickerView {
            print(textEditRows[row])
        } else if pickerView == backgroundColorPickerView {
            imagePickerView.backgroundColor = backgroundColorPickerViewTapped[row]
        } else {
            print("Empty")
        }
//        if self.pickerViewContent == "textEdit" {
//            print(textEditRows[row])
//        } else if self.pickerViewContent == "backgroundColor" {
//            imagePickerView.backgroundColor = backgroundColorPickerViewTapped[row]
//            print(backgroundColorRows[row])
//        } else {
//            print("Empty")
//        }
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
    
    
    @IBAction func textEditTapped(_ sender: Any) {
//        self.pickerViewContent = "textEdit"
        if textEditPickerView.isHidden {
//            textEditPickerView.reloadAllComponents()
            textEditPickerView.isHidden = false
            backgroundColorPickerView.isHidden = true
            pickerViewToolBar.isHidden = false
        } else if !(textEditPickerView.isHidden) {
            textEditPickerView.isHidden = true
            pickerViewToolBar.isHidden = true
        }
//            pickerView.reloadAllComponents()
//            pickerViewToolBar.isHidden = false
//        pickerView.reloadAllComponents()
//        pickerView.isHidden = pickerView.isHidden ? false : true
    }
    
    @IBAction func backgroundColorTapped(_ sender: Any) {
        
        if backgroundColorPickerView.isHidden {
            //            textEditPickerView.reloadAllComponents()
            textEditPickerView.isHidden = true
            backgroundColorPickerView.isHidden = false
            pickerViewToolBar.isHidden = true
        } else if !(backgroundColorPickerView.isHidden) {
            backgroundColorPickerView.isHidden = true
        }
        
//        self.pickerViewContent = "backgroundColor"
//        pickerView.reloadAllComponents()
//        if pickerView.isHidden {
//            self.pickerViewContent = "backgroundColor"
//            pickerView.reloadAllComponents()
//            pickerView.isHidden = false
//        } else if !(pickerView.isHidden) && (pickerViewContent == "backgroundColor") {
//            pickerView.isHidden = true
//        } else if !(pickerView.isHidden) && (pickerViewContent == "textEdit") {
//            pickerViewContent = "backgroundColor"
//            pickerView.reloadAllComponents()
//            pickerViewToolBar.isHidden = true
//        }
//        pickerView.isHidden = pickerView.isHidden ? false : true
//        pickerViewToolBar.isHidden = pickerViewToolBar.isHidden ? false : true
    }
    
    
    // MARK: The IBAction for opening the activity view
    @IBAction func shareButtonTapped(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            
            if success {
                self.save()
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.popToRootViewController(animated: true)
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
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: Declaring generateMemedImage Function
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        self.imagePickerView.frame.origin.y -= view.safeAreaInsets.top
        self.topTextField.frame.origin.y -= view.safeAreaInsets.top
        self.bottomTextField.frame.origin.y -= view.safeAreaInsets.top
        UIGraphicsBeginImageContext(self.imagePickerView.frame.size)
        //        view.frame.origin.y -= view.safeAreaInsets.top
        imagePickerView.drawHierarchy(in: self.imagePickerView.frame, afterScreenUpdates: true)
        topTextField.drawHierarchy(in: self.topTextField.frame, afterScreenUpdates: true)
        bottomTextField.drawHierarchy(in: self.bottomTextField.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //        view.frame.origin.y = 0
        self.imagePickerView.frame.origin.y = 0
        self.topTextField.frame.origin.y = 0
        self.bottomTextField.frame.origin.y = 0
        
        // Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: Declaring save Function
    func save() {
        // Update the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array on the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @objc func tapDetected() {
        if (textEditPickerView.isHidden) && (backgroundColorPickerView.isHidden) {
            navBar.isHidden = navBar.isHidden ? false : true
            toolBar.isHidden = navBar.isHidden
        }
    }

}
