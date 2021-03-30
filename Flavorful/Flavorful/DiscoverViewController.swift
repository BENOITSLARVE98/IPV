//
//  DiscoverViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/19/21.
//

import UIKit
class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    

    @IBOutlet var recipeCollectionView: UICollectionView!
    
    var recipes = [Recipe]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getRecipesFromApi()
    }
    
    
    //COLLECTION VIEW SETUP
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recipeCollectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        cell.recipeImageView.image = recipes[indexPath.row].image
        //cell.recipeImage.layer.borderWidth = 2
        //cell.recipeImage.layer.cornerRadius = 3
        //cell.layer.cornerRadius = 3
        cell.recipeNameLabel.text = recipes[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (recipeCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    //Recipe item selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "GoToDetailsPage", sender: self) // Segue to Details page
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsViewController {
            destination.recipe = recipes[index] // send one recipe card object to DetailsViewController based on the user's selection
        }
    }

}
