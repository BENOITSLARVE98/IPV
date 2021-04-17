//
//  DiscoverExtension.swift
//  Flavorful
//
//  Created by Slarve N. on 3/26/21.
//
import UIKit
import Foundation

extension DiscoverViewController {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Set API search string to search bar text
        if (!searchText.isEmpty) {
            searchedKey = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        recipes = [Recipe]() //Clear Recipes list before getting new ones
        getRecipesFromApi(tag: "", searchWord: searchedKey)
        DispatchQueue.main.async {
            self.recipeCollectionView.reloadData()
        }
    }
    

    func getRecipesFromApi(tag: String, searchWord: String) {
        
        let headers = [
            "x-rapidapi-host": "tasty.p.rapidapi.com",
            "x-rapidapi-key": "59d338597cmsh4f789cced9df6a2p1b0e7fjsna39bda851ccd"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tasty.p.rapidapi.com/recipes/list?from=0&size=100&tags=\(tag)&q=\(searchWord)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data
            else { return }
            
            do {
                //De-Serialize data object
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    var arrayOfIngredients = [String]()
                    
                    for firstLevelItem in json {
                        guard let result = firstLevelItem.value as? [[String: Any]]
                        else { continue
                        }
                        
                        for child in result {
                            guard let name = child["name"] as? String,
                                  let image = child["thumbnail_url"] as? String,
                                  let video = child["original_video_url"] as? String,
                                  let instructions = child["instructions"] as? [[String: Any]],
                                  let sections = child["sections"] as? [[String: Any]]
                            else { continue
                            }
                            
                            var numbersArray = [Int]()
                            var instructionsArray = [String]()
                            for item in instructions {
                                guard let stepNumber = item["position"] as? Int,
                                      let instructionText = item["display_text"] as? String
                                else { continue
                                }
                                numbersArray.append(stepNumber)
                                instructionsArray.append(instructionText)
                            }
                            
                            for item in sections {
                                guard let components = item["components"] as? [[String: Any]]
                                else { continue
                                }
                                for item in components {
                                    let ingredient = item["raw_text"] as? String
                                    arrayOfIngredients.append(ingredient ?? "")
                                }
                            }
                            
                            //Append elements to recipe array
                            //if self.recipe.count != 20 {
                                //print(recipe.count)
                            self.recipes.append(Recipe(name: name, imageString: image, videoUrl: video, numbersArray: numbersArray, instructionsArray: instructionsArray, ingredient: arrayOfIngredients))
                            //}
                        }
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.recipeCollectionView.reloadData()
            }
        })
        dataTask.resume()
    }

}
