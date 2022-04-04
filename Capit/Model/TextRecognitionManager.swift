//
//  TextRecognitionManager.swift
//  Capit
//
//  Created by Abdullah on 13/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import Vision
import VisionKit

class TextRecognitionManager {
    //To refactor current code, MVC
    //Didnt work.
    private var textString: String = ""
    
    func detectText(from image: UIImage) {
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                fatalError("Observations recieved are not valid.")
            }
            
            for observation in observations {
                guard let candidiate = observation.topCandidates(1).first else { return }
                DispatchQueue.main.async {
                    self.textString += candidiate.string
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
    
    func getTextString() -> String {
        return textString
    }
}
