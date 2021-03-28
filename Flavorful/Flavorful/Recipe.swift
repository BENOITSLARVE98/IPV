//
//  Recipe.swift
//  Flavorful
//
//  Created by Slarve N. on 3/26/21.
//

import Foundation
import UIKit

class Recipe: NSObject {
    
    //properties
    var name: String?
    var image: UIImage?
    var videoUrl: String?
    var numbersArray: [Int]?
    var instructionsArray: [String]?
    var ingredient: [String]?

    /* Initializers */
    init(name: String, imageString: String, ingredient: [String], videoUrl: String, numbersArray: [Int], instructionsArray: [String]) {
        self.name = name
        self.ingredient = ingredient
        self.videoUrl = videoUrl
        self.numbersArray = numbersArray
        self.instructionsArray = instructionsArray
        
        //The init will take care of dowloading the image
        if let url = URL(string: imageString) {

            do {
                let data = try Data(contentsOf: url)
                self.image = UIImage(data: data)
            }
            catch  {

            }
        }
    }
    
//    required convenience init?(coder: NSCoder) {
//        self.init(name: "String", imageString: "String", ingredient: ["String"], videoUrl: "String", numbersArray: [0], instructionsArray: ["String"])
//
//        name = coder.decodeObject(forKey: "name") as? String
//        //imageString = coder.decodeObject(forKey: "image") as? String
//        videoUrl = coder.decodeObject(forKey: "videoUrl") as? String
//        numbersArray = coder.decodeObject(forKey: "numArray") as? [Int]
//        instructionsArray = coder.decodeObject(forKey: "instructionsArray") as? [String]
//        ingredient = coder.decodeObject(forKey: "ingredient") as? [String]
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        //coder.encode(imageString, forKey: "image")
//        coder.encode(videoUrl, forKey: "videoUrl")
//        coder.encode(numbersArray, forKey: "numArray")
//        coder.encode(instructionsArray, forKey: "instructionsArray")
//        coder.encode(ingredient, forKey: "ingredient")
//    }

}
