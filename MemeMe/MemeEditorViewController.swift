//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jeffrey Chau on 9/09/2015.
//  Copyright (c) 2015 Tigerspike. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var previousText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldOptions(topTextField)
        setupTextFieldOptions(bottomTextField)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: IBActions Methods
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        presentViewControllerWithSourceType(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        presentViewControllerWithSourceType(.Camera)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: ["", generateMemedImage()], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {
            // Save image
            self.save()
            // Dismiss sharing VC
            let presentingVC = self.presentingViewController?.presentingViewController
            presentingVC?.dismissViewControllerAnimated(true, completion: {});
            // TODO: pop back to sent memes
//            self.navigationController?.popToRootViewControllerAnimated(true)
        })
    }
    
    @IBAction func cancelAll(sender: UIBarButtonItem) {
        imagePickerView.image = nil;
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // Get selected image and set to image view
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
        }
        // Dismiss image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        previousText = textField.text
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text.isEmpty) {
            textField.text = previousText
        }
    }
    
    // MARK: Convenience Methods
    
    func presentViewControllerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func save() {
        //Create the meme
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imagePickerView.image!, modifiedImage: generateMemedImage())
        
        // Add it to the memes array on the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func hideUI(b: Bool) {
        topToolbar.hidden = b
        bottomToolbar.hidden = b
        navigationController?.navigationBarHidden = b
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideUI(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideUI(false)
        return memedImage
    }
    
    func setupTextFieldOptions(textfield: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .Center
        textfield.delegate = self
    }
    
    // MARK: Keyboard Methods

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyBoardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyBoardHeight(notification: NSNotification) -> CGFloat {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

