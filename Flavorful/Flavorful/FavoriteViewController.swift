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
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
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

    
    func retrieveProfileInfo() {
        if let user = Auth.auth().currentUser {
            let db = Database.database().reference().child("users").child(user.uid)
            
            db.observe(DataEventType.value, with: { (snapshot) in
                let userInfo = snapshot.value as? [String : AnyObject] ?? [:]
                self.profileNameLabel.text = userInfo["name"] as? String
                self.profileEmailLabel.text = userInfo["email"] as? String
              })
        }
    }
    
    func retrieveRecipesSaved() {
        if let user = Auth.auth().currentUser {
            let rootRef = Firestore.firestore()
            let documentRef = rootRef.collection("favoriteRecipes").document(user.uid)
            
            documentRef.getDocument(completion: { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    document.data()?.forEach { item in
            
                    }
                
                } else {
                    print("Document does not exist")
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
