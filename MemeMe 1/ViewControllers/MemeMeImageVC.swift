//
//  ViewController.swift
//  MemeMe 1
//
//  Created by Admin on 1/15/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit


class MemeMeImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: - Variables
    var activeField: UITextField?

    //MARKL: - Delegates
    let imagePicker = UIImagePickerController()
    
    //MARK: - Outlets
    @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var imageTextFieldCollection: [UITextField]!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Initilaizer
    func initialLoadUI(){
        checkCameraAvailability()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        shareButtonOutlet.isEnabled = false
        configureTextField(textField: topTextField)
        configureTextField(textField: bottomTextField)
    }
    
    func configureTextField(textField: UITextField){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }

    //MARK: - Button Actions
    @IBAction func shareButtonPressed(_ sender: Any) {
        shareButton()
    }
    
    //Shows photo library
    @IBAction func photoLibraryButton(_ sender: Any) {
        showImagePicker(source: .photoLibrary)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        showImagePicker(source: .camera)
    }
    
    @IBAction func imageViewButton(_ sender: Any) {
        showImagePicker(source: .photoLibrary)
    }
    
    
    
    //Gives ability to select images from camera roll
    func showImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            imagePicker.sourceType = source
            print("Selected Source: \(source)")
            present(imagePicker, animated: true, completion: nil)
        }else {
            print("No Camera On Device")
        }
    }
    
    //Checks if the device has a front or back camera or one at all
    func checkCameraAvailability(){
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    //When image picker selects media. Images is then placed in the image view on screen
    //then it can be memed
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            shareButtonOutlet.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Text Attributes
    //Richtext for meme lettering
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2.5
    ]

    //MARK: - Save Meme
    //saves the meme as a Stuct of Meme.
    func saveMeme(){
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, originalImage: imageView.image!, memeImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        performSegue(withIdentifier: "tabViewSegue", sender: self)
    }
    
    //Share button located in the top left.
    //Takes the memed image and gives you the ability to save or share it.
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

    //MARK: - Create Meme Image
    //Creates the meme image with the new text into the image. Returns the created meme
    func generateMemedImage() -> UIImage {
        // Render view to an image
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navigationController?.setToolbarHidden(true, animated: false)
        bottomToolBar.isHidden = false
        topToolBar.isHidden = false
        return memedImage
    }
}

