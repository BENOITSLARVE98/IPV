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
    @IBOutlet var saveOrDeleteRecipeBtn: UIBarButtonItem!
    
    
    var recipe: Recipe!
    var senderReceived: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recipeNameLabel.text = recipe.name
        recipeImageView.image = recipe.image
        setupActionbBarButton()
    }
    
    func setupActionbBarButton() {
        if let sender = senderReceived {
            //Change button image based on sender
            if sender == "Discover" {
                saveOrDeleteRecipeBtn.image = UIImage(systemName: "heart.fill")
                
            } else {
                saveOrDeleteRecipeBtn.image = UIImage(systemName: "trash.fill")
            }
        }
    }
    
    
    
    @IBAction func saveOrDeleteRecipe(_ sender: UIBarButtonItem) {
        
        if let sender = senderReceived {
            switch sender {
            case "Discover":
                //Save Recipe
                saveRecipe()
            case "Favorite":
                //Delete Recipe
                deleteRecipe()
            default:
                print("")
            }
        }
    }
    
    func deleteRecipe() {
        //Delete selected recipe from Firebase
        
//        if let user = Auth.auth().currentUser {
//            Database.database().reference()
//                .child("users").child("recipes").child(user.uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                    guard let values = snapshot.value as? [String: Any] else {
//                        return
//                    }
//                    for (_, value) in values {
//                        guard let recipe = value as? [String: Any],
//                              let name = recipe["name"] as? String else {
//                            continue
//                        }
//
//                        //Delete recipe with the matching name
//                        if name == self.recipeNameLabel.text {
//                            //Delete recipe with matching name in Firebase
//                            Database.database().reference().child("users").child("recipes").child(user.uid).removeValue()
//                        }
//                    }
//                })
//        }
        
    }
    
    func saveRecipe() {
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
                        
                        //Save recipe to firestore
                        Firestore.firestore().collection("recipes").document(user.uid).setData(recipeDict)
                        //Save recipe collection inside users collection
//                        Firestore.firestore().collection("users").document(user.uid).collection("recipes").document(self.recipe.name!).setData(recipeDict) { err in
//                            if let err = err {
//                                print("Error writing document: \(err)")
//                            } else {
//                                print("Document successfully written!")
//                            }
//                        }
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
