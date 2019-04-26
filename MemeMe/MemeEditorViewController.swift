//
//  ViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 06/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: IBOutlets
    
    @IBOutlet weak var pickedImageView: UIImageView!
    
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
    @IBOutlet weak var textEditPickerViewToolBar: UIToolbar!
    @IBOutlet weak var textSizeSlider: UISlider!
    
    // MARK: Global variables
    
    var meme: Meme!
    
    var topTextFieldEdited = false  // A variable to check if topTextField has been edited before.
    var bottomTextFieldEdited = false  // A variable to check if bottomTextField has been edited before.
    
    var textEditRows = [
        "HelveticaNeue-CondensedBlack",
        "HoeflerText-Black",
        "MalayalamSangamMN-Bold",
        "Menlo-Bold",
        "MarkerFelt-Wide",
        "Optima-ExtraBlack"
    ]
    
    var backgroundColorRows = ["black", "white", "red", "blue", "green", "gray"]
    var backgroundColorRowsUIColor: [UIColor] = [.black, .white, .red, .blue, .green, .gray]
    
    var textSize: CGFloat!
    
    // MARK: View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDelegatedControl(topTextField, bottomTextField, textEditPickerView, backgroundColorPickerView)
        // Check if the meme is edited or new.
        if meme != nil {
            shareButton.isEnabled = true
            textSizeSlider.value = Float(meme.textFont.pointSize)
            
            attributeText(topTextField, font: meme.textFont, text: meme.topText)
            attributeText(bottomTextField, font: meme.textFont, text: meme.bottomText)
            attributeImage(image: meme.originalImage, backgroundColor: meme.backgroundColor)
            selectPickerViewRow(textEditPickerView, rows: self.textEditRows, element: (meme.textFont?.fontName)!)
            selectPickerViewRow(backgroundColorPickerView, rows: self.backgroundColorRowsUIColor, element: (meme.backgroundColor)!)
        } else {
            shareButton.isEnabled = false
            
            attributeText(topTextField, font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, text: "TOP")
            attributeText(bottomTextField, font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, text: "BOTTOM")
            attributeImage(image: nil, backgroundColor: .black)
        }
        
        // Assign alpha value to pickers and secondary bars
        setAlpha(0.8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideMainBars(navBar: true, tabBar: true)
        hidePickers(textEditPicker: true, backgroundColorPicker: true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: TextField lifecycle methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hidePickers(textEditPicker: true, backgroundColorPicker: true)
        emptyTextField(textField)  // Empty the text field when editing it for the first time.
    }
    
    // MARK: TextField manipulation methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    func attributeText(_ textField: UITextField, font: UIFont, text: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [  // Default text attributes for textFields.
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: font,
            .strokeWidth:  -3
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    func editTextField(top: Bool, bottom: Bool) {
        topTextFieldEdited = top
        bottomTextFieldEdited = bottom
    }
    
    func emptyTextField(_ textField: UITextField) {
        if textField == topTextField && topTextFieldEdited == false  {
            textField.text = ""
            topTextFieldEdited = true
        } else if textField == bottomTextField && bottomTextFieldEdited == false {
            textField.text = ""
            bottomTextFieldEdited = true
        }
    }
    
    // MARK: Keyboard manipulation methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: ImageView manipulation method
    
    func attributeImage(image: UIImage?, backgroundColor: UIColor) {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        pickedImageView.addGestureRecognizer(singleTap)  // make the imageView clickable.
        
        pickedImageView.image = image
        pickedImageView.backgroundColor = backgroundColor
        pickedImageView.contentMode = .scaleAspectFit
        pickedImageView.clipsToBounds = true
        pickedImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapDetected() {
        if (textEditPickerView.isHidden) && (backgroundColorPickerView.isHidden) {
            navBar.isHidden = navBar.isHidden ? false : true
            toolBar.isHidden = navBar.isHidden
        } else {
            hidePickers(textEditPicker: true, backgroundColorPicker: true)
        }
    }
    
    // MARK: ImagePicker manipulation methods
    
    func chooseImageFrom(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImageView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: PickerView manipulation methods
  
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
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == textEditPickerView {
            return textEditRows[row]
        } else if pickerView == backgroundColorPickerView {
            return backgroundColorRows[row]
        } else {
            return "Empty"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == textEditPickerView {
            topTextField.font = UIFont(name: textEditRows[row], size: CGFloat(Int(textSizeSlider.value)))
            bottomTextField.font = UIFont(name: textEditRows[row], size: CGFloat(Int(textSizeSlider.value)))
        } else if pickerView == backgroundColorPickerView {
            pickedImageView.backgroundColor = backgroundColorRowsUIColor[row]
        } else {
            print("Empty")
        }
    }
    
    // PickerView select row method
    func selectPickerViewRow(_ pickerView: UIPickerView, rows: [Any], element: Any) {
        if pickerView == textEditPickerView {
            let typeRows = rows as! [String]
            let typeElement = element as! String
            
            let index = typeRows.firstIndex(of: typeElement)
            pickerView.selectRow(index!, inComponent: 0, animated: false)
        } else if pickerView == backgroundColorPickerView {
            let typeRows = rows as! [UIColor]
            let typeElement = element as! UIColor
            
            let index = typeRows.firstIndex(of: typeElement)
            pickerView.selectRow(index!, inComponent: 0, animated: false)
        }
    }
    
    // MARK: Meme manipulation methods
    
    func save() {
        // Create a meme.
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, textFont: topTextField.font, backgroundColor: pickedImageView.backgroundColor, originalImage: pickedImageView.image!, memedImage: generateMemedImage())
        // Check if the meme got edited.
        if self.meme == nil || isMemeEdited(meme) {
            // Add meme to the memes array on the Application Delegate.
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            
            appDelegate.memes.append(meme)
        }
    }
    
    func isMemeEdited(_ meme: Meme) -> Bool {
        if self.meme != nil {
            let checkTopText = meme.topText == self.meme.topText
            let checkBottomText = meme.bottomText == self.meme.bottomText
            let checkTextFont = meme.textFont == self.meme.textFont
            let checkBackgroundColor = meme.backgroundColor == self.meme.backgroundColor
            let checkOriginalImage = meme.originalImage == self.meme.originalImage
            let checkAll = checkTopText && checkBottomText && checkTextFont && checkBackgroundColor && checkOriginalImage
            
            return !checkAll
        } else {
            return false
        }
    }
    
    func generateMemedImage() -> UIImage {
        hideSecondaryBars(navBar: true, toolBar: true)  // Hide secondary bars.
        moveYCoordination(true)  // Move objects to the top of the screen.
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.pickedImageView.frame.size)
        pickedImageView.drawHierarchy(in: self.pickedImageView.frame, afterScreenUpdates: true)
        topTextField.drawHierarchy(in: self.topTextField.frame, afterScreenUpdates: true)
        bottomTextField.drawHierarchy(in: self.bottomTextField.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        moveYCoordination(false)  // Move objects back to their place.
        hideSecondaryBars(navBar: false, toolBar: false)  // Show secondary bars.
        
        return memedImage
    }
    
    func moveYCoordination(_ move: Bool) {
        if move {
            self.pickedImageView.frame.origin.y -= view.safeAreaInsets.top
            self.topTextField.frame.origin.y -= view.safeAreaInsets.top
            self.bottomTextField.frame.origin.y -= view.safeAreaInsets.top
        } else if !move {
            self.pickedImageView.frame.origin.y = 0
            self.topTextField.frame.origin.y = 0
            self.bottomTextField.frame.origin.y = 0
        }
    }
    
    // MARK: Assign delegate & dataSource to self method
    
    func setDelegatedControl(_ objects: Any...) {
        for object in objects {
            switch(object) {
            case let object as UITextField:
                object.delegate = self
            case let object as UIPickerView:
                object.delegate = self
                object.dataSource = self
            case _:
                print("Incorrect type")
            }
        }
    }
    
    // MARK: Bars & Pickers properties manipulation methods
    
    func setAlpha(_ alpha: CGFloat) {
        navBar.alpha = alpha
        toolBar.alpha = alpha
        textEditPickerView.alpha = alpha
        backgroundColorPickerView.alpha = alpha
    }
    
    func hideMainBars(navBar: Bool, tabBar: Bool) {
        self.navigationController?.navigationBar.isHidden = navBar
        self.tabBarController?.tabBar.isHidden = tabBar
    }
    
    func hideSecondaryBars(navBar: Bool, toolBar: Bool) {
        self.navBar.isHidden = navBar
        self.toolBar.isHidden = toolBar
    }
    
    func hidePickers(textEditPicker: Bool, backgroundColorPicker: Bool) {
        self.textEditPickerView.isHidden = textEditPicker
        self.textEditPickerViewToolBar.isHidden = textEditPicker
        self.backgroundColorPickerView.isHidden = backgroundColorPicker
        
    }
    
    // MARK: IBActions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        chooseImageFrom(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageFrom(source: .camera)
    }
    
    @IBAction func textEditButtonTapped(_ sender: Any) {
        if textEditPickerView.isHidden {
            hidePickers(textEditPicker: false, backgroundColorPicker: true)
        } else if !(textEditPickerView.isHidden) {
            hidePickers(textEditPicker: true, backgroundColorPicker: true)
        }
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        let sliderValue = CGFloat(Int(textSizeSlider.value))
        topTextField.font = topTextField.font?.withSize(sliderValue)
        bottomTextField.font = bottomTextField.font?.withSize(sliderValue)
    }
    
    @IBAction func backgroundColorButtonTapped(_ sender: Any) {
        if backgroundColorPickerView.isHidden {
            hidePickers(textEditPicker: true, backgroundColorPicker: false)
        } else if !(backgroundColorPickerView.isHidden) {
            hidePickers(textEditPicker: true, backgroundColorPicker: true)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        hidePickers(textEditPicker: true, backgroundColorPicker: true)
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                self.hideMainBars(navBar: false, tabBar: false)
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        attributeText(topTextField, font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, text: "TOP")
        attributeText(bottomTextField, font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, text: "BOTTOM")
        attributeImage(image: nil, backgroundColor: .black)
        editTextField(top: false, bottom: false)
        shareButton.isEnabled = false
        hideMainBars(navBar: false, tabBar: false)
        hidePickers(textEditPicker: true, backgroundColorPicker: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
