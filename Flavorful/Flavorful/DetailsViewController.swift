//
//  DetailsViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/27/21.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Firebase

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var ingredientsTable: UITableView!
    
    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recipeNameLabel.text = recipe.name
        recipeImageView.image = recipe.image
    }
    
    @IBAction func saveRecipe(_ sender: UIBarButtonItem) {
        
        if let user = Auth.auth().currentUser {
            
            var recipeDict: [String: Any] = [
                "name": recipe.name!,
                "imageString": "",
                "videoUrl": recipe.videoUrl!,
                "numbersArray": recipe.numbersArray!,
                "instructionsArray": recipe.instructionsArray!,
                "ingredient": recipe.ingredient!
            ]
            
            //Get Firebase reference to Save profile image to Storage
            let storageRef = Storage.storage().reference()
            let storageProfileRef = storageRef.child("recipeImages").child(user.uid)
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            //Save Recipe image data to firebase Stoarge
            storageProfileRef.putData((self.recipe.image?.jpegData(compressionQuality: 0.5))!, metadata: metaData, completion: { (storageMetaData, error) in
                if error != nil {
                    return
                }
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if let metaImageUrl = url?.absoluteString{
                        recipeDict["imageString"] = metaImageUrl
                        
                        //Save recipe to firebase realtime database
                        Database.database().reference().child("users").child("recipes").child(user.uid).childByAutoId().setValue(recipeDict)
                    }
                })
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredient!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient_Cell_ID", for: indexPath) as? DetailsIngredientCell
        else{return tableView.dequeueReusableCell(withIdentifier: "Ingredient_Cell_ID", for: indexPath)}
        
        // Configure the cell...
        cell.ingredientName.text = recipe.ingredient![indexPath.row]
        
        return cell
    }

    @IBAction func goToStepByStep(_ sender: Any) {
        performSegue(withIdentifier: "goToStepByStep", sender: self) // Segue to step by step page
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? StepByStepViewController {
            destination.recipe = recipe!
        }
    }
    

}
