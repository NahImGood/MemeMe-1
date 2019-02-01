//
//  ViewController.swift
//  MemeMe 1
//
//  Created by Admin on 1/15/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit


class MemeMeImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Global Variables
    var activeField: UITextField?

    //MARKL: Delegates
    let imagePicker = UIImagePickerController()
    
    //MARK: Outlets
    @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var imageTextFieldCollection: [UITextField]!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoadUI()
        
    }
    
    //MARK: Initilaizer Func
    func initialLoadUI(){
        checkCameraAvailability()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        shareButtonOutlet.isEnabled = false
        configureTextField(textField: topTextField)
        configureTextField(textField: bottomTextField)
    }
        
 
    func configureTextField(textField: UITextField){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }

    //MARK: Button Actions
    @IBAction func shareButtonPressed(_ sender: Any) {
        shareButton()
    }

    @IBAction func photoLibraryButton(_ sender: Any) {
        showImagePicker(source: .photoLibrary)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        showImagePicker(source: .camera)
    }
    
    func showImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            imagePicker.sourceType = source
            print("Selected Source: \(source)")
            present(imagePicker, animated: true, completion: nil)
        }else {
            print("No Camera On Device")
        }
    }
    
    func checkCameraAvailability(){
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            shareButtonOutlet.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2.5
    ]

    func saveMeme(){
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, originalImage: imageView.image!, memeImage: generateMemedImage())
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
            //let appdelegate = object as! AppDelegate
        appdelegate.memes.append(meme)
        
    }

    func generateMemedImage() -> UIImage {
        // Render view to an image
        print("Tool bar Vanishes")
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navigationController?.setToolbarHidden(true, animated: false)
        print("Tool bar Returns")
        bottomToolBar.isHidden = false
        topToolBar.isHidden = false
        return memedImage
    }
    
    func shareButton(){
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.saveMeme()
            }
            self.dismiss(animated: true, completion: nil)
        }
        present(activityController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
}

