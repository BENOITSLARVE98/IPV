//
//  Recipe.swift
//  Flavorful
//
//  Created by Slarve N. on 3/26/21.
//

import Foundation
import UIKit

class Recipe {
    
    //properties
    var name: String?
    var image: UIImage?
    var videoUrl: String?
    var numbersArray: [Int]?
    var instructionsArray: [String]?
    var ingredient: [String]?

    /* Initializers */
    init(name: String, imageString: String, videoUrl: String, numbersArray: [Int], instructionsArray: [String], ingredient: [String]) {
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

}
