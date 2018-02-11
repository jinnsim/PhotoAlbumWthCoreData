//
//  CameraViewController.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 10..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit 
typealias CreateStory = (Photos) -> Void
class CameraViewController: UIViewController {
 
    @IBOutlet fileprivate var captureButton: UIButton!
    @IBOutlet fileprivate var capturePreviewView: UIView!
 
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    let cameraController = CameraController()
    var photoTakeCount = 0
    var photos = [Data]()
    var story = Photos(context: CoreDataManager(modelName: "Story").managedObjectContext)
    var createStory: CreateStory?
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        styleButtons()
        stylePhotoCountLabel()
        configureCameraController()
        
    }
  
}

extension CameraViewController {

    func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }
    
    func styleButtons() {
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.borderWidth = 2
        
        cancelButton.layer.cornerRadius = min(cancelButton.frame.width, cancelButton.frame.height) / 2
        
        doneButton.layer.borderColor = UIColor.black.cgColor
        doneButton.layer.borderWidth = 2
        
        doneButton.layer.cornerRadius = min(doneButton.frame.width, doneButton.frame.height) / 2
    }
    
    func stylePhotoCountLabel() {
        photoCountLabel.layer.borderColor = UIColor.black.cgColor
        photoCountLabel.layer.borderWidth = 2
        
        photoCountLabel.layer.cornerRadius = min(photoCountLabel.frame.width, photoCountLabel.frame.height) / 2
    }
}
    
extension CameraViewController {
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Change Camera Icon"), for: .normal)
            
        case .some(.rear):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Change Camera Icon"), for: .normal)
            
        case .none:
            return
        }
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            let newImageData = UIImageJPEGRepresentation(image,1)
          
            self.photos.append(newImageData!)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.photos)
           
            self.story.updatedAt = Date().updateDate()
            self.story.createdAt = Date().yearAndMonth()
            self.story.photo = encodedData
           updatePhotoCountLabel()
        }
        
        func updatePhotoCountLabel(){
            self.photoTakeCount += 1
            self.photoCountLabel.text = "\(self.photoTakeCount)"
        }
    }
    
    
    @IBAction func touchedCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func touchedDone(_ sender: Any) {
        if self.photos.count > 0 { self.createStory?(self.story) }
        self.dismiss(animated: true) 
    }
}

