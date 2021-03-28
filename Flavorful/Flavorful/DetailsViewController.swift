//
//  DetailsViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/27/21.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var ingredientsTable: UITableView!
    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recipeName.text = recipe.name
        recipeImage.image = recipe.image
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
