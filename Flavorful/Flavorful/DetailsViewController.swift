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
import AVKit

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
    
    @IBAction func playVideo(_ sender: Any) {
        playVideoPlayer()
    }
    
    func playVideoPlayer() {
        let videoUrl = URL(string: recipe.videoUrl!)
        let player = AVPlayer(url: videoUrl!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
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
        
        //Delete selected recipe from Firestore
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("recipes").document(user.uid).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                //Save data to recipe object
                let name = data["name"] as? String
                if name == self.recipeNameLabel.text {
                    //Delete recipe with matching name in Firestore
                    Firestore.firestore().collection("recipes").document(user.uid).delete()
                }
            }
        }
        
        //Delete recipe from local storage
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "recipe")
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
                        
                        //Save Recipe to local storage for offline use
                        self.saveRecipeToLocalStorage()
                    }
                })
            })
        }
    }
    
    func saveRecipeToLocalStorage() {
        let defaults = UserDefaults.standard
        //Save recipe to data
        let recipeData = try! NSKeyedArchiver.archivedData(withRootObject: recipe!, requiringSecureCoding: false)
        defaults.set(recipeData, forKey: "recipe")
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
