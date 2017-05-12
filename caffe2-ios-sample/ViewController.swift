//
//  ViewController.swift
//  caffe2-ios-sample
//
//  Created by Nutchaphon Rewik on 09/05/2017.
//  Copyright © 2017 FuseCore. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    let caffe = Caffe(initNetName: "exec_net", predictNetName: "predict_net")
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
    }
    
    func predict(with image: UIImage) {
        imageView.image = image
        let results = caffe.predict(from: image)
        let topFiveResults = results.prefix(5)
        var text = "Top Five Predictions\n\n"
        for result in topFiveResults {
            let confidence = String(format: "%.4f", result.confidence)
            text += "\(confidence) \(result.itemName)\n"
        }
        predictionLabel.text = text
    }
    

    @IBAction func selectImageButtonDidTouch() {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UINavigationControllerDelegate {}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        predict(with: image)
    }
}

