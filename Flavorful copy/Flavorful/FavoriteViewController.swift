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
        retrieveProfileInfo()
        retrieveRecipesSaved()
    }
    
    
    @IBAction func editProfileBtn(_ sender: UIButton) {
        
    }
    
    //COLLECTION VIEW SETUP
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    
    func retrieveProfileInfo() {
    
        if let user = Auth.auth().currentUser {
            Database.database().reference()
                .child("users").child(user.uid).observe(DataEventType.value, with: { (snapshot) in
                    guard let values = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    self.profileNameLabel.text = values["name"] as? String
                    self.profileEmailLabel.text = values["email"] as? String
                    let imageUrl = values["profileImageUrl"] as? String
                    
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
                })
        }
        
        
    }
    
    
    func retrieveRecipesSaved() {
        
        if let user = Auth.auth().currentUser {
            Database.database().reference()
                .child("users").child("recipes").child(user.uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    guard let values = snapshot.value as? [String: Any] else {
                        return
                    }
                    for (_, value) in values {
                        guard let recipe = value as? [String: Any],
                              let name = recipe["name"] as? String,
                              let imageString = recipe["imageString"] as? String,
                              let videoUrl = recipe["videoUrl"] as? String,
                              let numbersArray = recipe["numbersArray"] as? [Int],
                              let instructionsArray = recipe["instructionsArray"] as? [String],
                              let ingredient = recipe["ingredient"] as? [String] else {
                            continue
                        }
                        self.recipes.append(Recipe(name: name, imageString: imageString, videoUrl: videoUrl, numbersArray: numbersArray, instructionsArray: instructionsArray, ingredient: ingredient))
                    }
                    DispatchQueue.main.async {
                        self.favoriteCollectionView.reloadData()
                    }
                })
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



//            let rootRef = Firestore.firestore()
//            let documentRef = rootRef.collection("favoriteRecipes").document(user.uid)
//
//            documentRef.getDocument(completion: { (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
//                    document.data()?.forEach { item in
//
//                    }
//
//                } else {
//                    print("Document does not exist")
//                }
//            })


