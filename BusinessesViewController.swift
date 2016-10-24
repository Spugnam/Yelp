//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        mySearchBar.delegate = self
        
        // Add SearchBar
        self.navigationItem.titleView = mySearchBar
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            return filteredBusinesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinesCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({ (Business) -> Bool in //look for seach text in busines name or description
            let booleanname = Business.name?.range(of: searchText) != nil
            let booleanDescription = Business.categories?.range(of: searchText) != nil
            let booleanAddress = Business.address?.range(of: searchText) != nil
            let booleanfilter = booleanname || booleanDescription || booleanAddress
            return booleanfilter
        })
        
        tableView.reloadData()
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let deals = filters["deal"] as? Bool
        let distanceSelected = filters["distance"] as? Double
        
        
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: deals) { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredBusinesses = businesses
            
            //Filter for distance
            
            var businessesWithinDistance = [Business]()
            
            for business in self.filteredBusinesses {
                let distanceString = (business.distance)!
                let indexEndOfText = distanceString.index(distanceString.endIndex, offsetBy: -3)    // remove " mi"
                let distanceDouble = Double(distanceString.substring(to: indexEndOfText))
                if (distanceDouble! < distanceSelected!) {
                    businessesWithinDistance.append(business)
                }
            }
            self.filteredBusinesses = businessesWithinDistance
            
            self.tableView.reloadData()
        }
    }
    

}
