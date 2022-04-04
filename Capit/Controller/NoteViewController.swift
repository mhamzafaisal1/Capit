//
//  NoteViewController.swift
//  Capit
//
//  Created by Abdullah on 08/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import RealmSwift
import Vision
import VisionKit

class NoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var noteTextView: UITextView!
    let realm = try! Realm()
    
    var selectedNote: Note?
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        noteTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = selectedNote?.title
        noteTextView.font = UIFont(name: "RobotoMono-Medium", size: 16)
        if let noteText = selectedNote?.text {
            noteTextView.text = noteText
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        print("TextViewDidChange")
//        try! realm.write {
//            selectedNote?.text = noteTextView.text
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Every time view dissapears, data on realm is saved.
        try! realm.write {
            selectedNote?.text = noteTextView.text
        }
    }

    
    @objc func dismissKeyboard(){
    //Causes the view to resign from the status of first responder.
    noteTextView.endEditing(true)
    }
    
    
    //MARK: - AdjustKeyboardHeight
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        noteTextView.scrollIndicatorInsets = noteTextView.contentInset

        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    
}

//MARK: - ImagePickerDelegate
extension NoteViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            detectText(from: image)
        }
    }
    
    func detectText(from image: UIImage) {
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                fatalError("Observations recieved are not valid.")
            }
            
            for observation in observations {
                guard let candidiate = observation.topCandidates(1).first else { return }
                DispatchQueue.main.async {
                    self.noteTextView.text += candidiate.string
                }
                
            }
        }
        
        request.recognitionLevel = .accurate
        
        let requests = [request]
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageToDetect = image.cgImage else {
                fatalError("Missing Image")
            }
            
            let handler = VNImageRequestHandler(cgImage: imageToDetect, options: [:])
            
            try? handler.perform(requests)
        }
    }
        
}

