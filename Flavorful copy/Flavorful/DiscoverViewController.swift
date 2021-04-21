//
//  DiscoverViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/19/21.
//

import UIKit
class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    


    @IBOutlet var filterButtons: [UIButton]!
    @IBOutlet var recipeCollectionView: UICollectionView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    var recipes = [Recipe]()
    var index = 0
    let mySender = "Discover"
    
    var searchedKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load popular recipe feed
        getRecipesFromApi(tag: "under_30_minutes",searchWord: "")
    }
    
    @IBAction func setupFiltersBtn(_ sender: UIButton) {
        switch (sender as AnyObject).tag {
        case 0: //Popular
            recipes = [Recipe]() //Clear Recipes list before getting new ones
            getRecipesFromApi(tag: "under_30_minutes", searchWord: "")
            self.recipeCollectionView.reloadData()
            //sender.tintColor = UIColor.white
            //sender.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.3137254902, blue: 0.2901960784, alpha: 1)
        
        case 1: //Indian
            recipes = [Recipe]() //Clear Recipes list before getting new ones
            getRecipesFromApi(tag: "indian", searchWord: "")
            self.recipeCollectionView.reloadData()
            //sender.tintColor = UIColor.white
            //sender.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.3137254902, blue: 0.2901960784, alpha: 1)
        case 2: //Caribbean
            recipes = [Recipe]() //Clear Recipes list before getting new ones
            getRecipesFromApi(tag: "caribbean", searchWord: "")
            self.recipeCollectionView.reloadData()
            //sender.tintColor = UIColor.white
            //sender.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.3137254902, blue: 0.2901960784, alpha: 1)
        case 3: //African
            recipes = [Recipe]() //Clear Recipes list before getting new ones
            getRecipesFromApi(tag: "african", searchWord: "")
            self.recipeCollectionView.reloadData()
            //sender.tintColor = UIColor.white
            //sender.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.3137254902, blue: 0.2901960784, alpha: 1)
        case 4: //Mexican
            recipes = [Recipe]() //Clear Recipes list before getting new ones
            getRecipesFromApi(tag: "mexican", searchWord: "")
            self.recipeCollectionView.reloadData()
            //sender.tintColor = UIColor.white
            //sender.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.3137254902, blue: 0.2901960784, alpha: 1)
        case 5: //German
            recipes = [Recipe]() //Clear Recipes list before getting new ones
            getRecipesFromApi(tag: "german", searchWord: "")
            self.recipeCollectionView.reloadData()
            //sender.tintColor = UIColor.white
            //sender.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.3137254902, blue: 0.2901960784, alpha: 1)
        default:
            print("")
        }
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
            destination.senderReceived = mySender
        }
    }

}
