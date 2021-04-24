//
//  FavoriteViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/29/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase

class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var favoriteCollectionView: UICollectionView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileEmailLabel: UILabel!
    
    var recipes = [Recipe]()
    var index = 0
    let mySender = "Favorite"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayUserInfo()
        getSavedRecipes()
    }
    
    
    //COLLECTION VIEW SETUP
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.recipes.count == 0) {
            self.favoriteCollectionView.setEmptyMessage("No favorites to show :(")
        } else {
            self.favoriteCollectionView.restore()
        }
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.recipeImageView.image = recipes[indexPath.row].image
        cell.recipeNameLabel.text = recipes[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (favoriteCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    //Recipe item selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "GoToDetailsPage", sender: self) // Segue to Details page
    }

    
    func displayUserInfo() {
        
        //Retrieve user profile data from Firestore
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                //Display user data
                self.profileNameLabel.text = data["name"] as? String
                self.profileEmailLabel.text = data["email"] as? String
                let imageUrl = data["profileImageUrl"] as? String
                
                let storageRef = Storage.storage().reference(forURL: imageUrl!)
                storageRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
                    if let _error = error{
                        print(_error)
                    } else {
                        if let _data  = data {
                            self.profileImageView.image = UIImage(data: _data)
                        }
                    }
                }
            }
        }
        
    }
    
    
    func getSavedRecipes() {
        
        //Retrieve saved recipes from firestore
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("recipes").document(user.uid).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    //If recipe document is empty reset favorites view
                    self.recipes = [Recipe]()
                    self.favoriteCollectionView.reloadData()
                    return
                }
                
                //Save data to recipe object
                let name = data["name"] as? String
                let imageString = data["imageString"] as? String
                let videoUrl = data["videoUrl"] as? String
                let numbersArray = data["numbersArray"] as? [Int]
                let instructionsArray = data["instructionsArray"] as? [String]
                let ingredient = data["ingredient"] as? [String]
                
                self.recipes.append(Recipe(name: name!, imageString: imageString!, videoUrl: videoUrl!, numbersArray: numbersArray!, instructionsArray: instructionsArray!, ingredient: ingredient!))
                
                self.favoriteCollectionView.reloadData()
                
            }
        }
    }
    
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsViewController {
            destination.recipe = recipes[index] // send one recipe card object to DetailsViewController based on the user's selection
            destination.senderReceived = mySender
        }
    }

}


