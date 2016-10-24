//
//  FiltersViewController.swift
//  Yelp
//
//  Created by quentin picard on 10/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    let sections = ["Deal", "Distance", "Sort by", "Categories"]

    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var switchStates = [Int:Bool]()
    var dealSwitch = false
    var distances = [0.5, 1, 5, 20]
    var distanceSelected = 0
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        var filters = [String : AnyObject]()
        
        // update Deals filter
        filters["deal"] = dealSwitch as AnyObject
        
        //update Distance filter
        filters["distance"] = distances[distanceSelected] as AnyObject
        
        // update categories selected
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            return self.sections[section] + " " + String(distances[distanceSelected]) + " miles"
        } else {
            return self.sections[section]
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0  :  // Deal
            return 1
            
        case 1  :  // Distance
            return distances.count
            
        case 2: // Sort by
            return 1
            
        case 3 :  // Categories
            return categories.count
            
        default :
            print( "no section selected")
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "")
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        switch indexPath.section {
        case 0  :  // Deal
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.isOn = dealSwitch
            
        case 1  :  // Distance - disable switches and update DistanceSelected when row selected
            cell.switchLabel.text = " \(distances[indexPath.row]) miles"
            if distanceSelected == indexPath.row {
                cell.delegate = self
                cell.onSwitch.isOn = true
            } else{
                cell.delegate = self
                cell.onSwitch.isOn = false
            }
            
            
        case 2: // Sort by
            cell.switchLabel.text = "Other Sort"
            
        case 3 :  // Categories
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            
        default :
            print( "no section selected")
        }
        
        return cell
    }
    

//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//        if indexPath.section == 1 {
//            distanceSelected = indexPath.row // 0, 1, 2 or 3
//            tableView.reloadData()
//        }
//    }
    
    func switchCell(switchCell: SwitchCell, didChangedValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        switch indexPath.section {
        case 0  :  // Deal
            dealSwitch = value
            
        case 1  :  // Distance
            distanceSelected = indexPath.row // 0, 1, 2 or 3
            tableView.reloadData()
            
        case 2:  // Sort by
            break
            
        case 3 :  // Categories
            switchStates[indexPath.row] = value
            
        default :
            print( "no section identified")
        }
        

    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

    let categories: [[String:String]] = [["name" : "Afghan", "code": "afghani"],
                                         ["name" : "African", "code": "african"],
                                         ["name" : "American, New", "code": "newamerican"],
                                         ["name" : "American, Traditional", "code": "tradamerican"],
                                         ["name" : "Arabian", "code": "arabian"],
                                         ["name" : "Argentine", "code": "argentine"],
                                         ["name" : "Armenian", "code": "armenian"],
                                         ["name" : "Asian Fusion", "code": "asianfusion"],
                                         ["name" : "Asturian", "code": "asturian"],
                                         ["name" : "Australian", "code": "australian"],
                                         ["name" : "Austrian", "code": "austrian"],
                                         ["name" : "Baguettes", "code": "baguettes"],
                                         ["name" : "Bangladeshi", "code": "bangladeshi"],
                                         ["name" : "Barbeque", "code": "bbq"],
                                         ["name" : "Basque", "code": "basque"],
                                         ["name" : "Bavarian", "code": "bavarian"],
                                         ["name" : "Beer Garden", "code": "beergarden"],
                                         ["name" : "Beer Hall", "code": "beerhall"],
                                         ["name" : "Beisl", "code": "beisl"],
                                         ["name" : "Belgian", "code": "belgian"],
                                         ["name" : "Bistros", "code": "bistros"],
                                         ["name" : "Black Sea", "code": "blacksea"],
                                         ["name" : "Brasseries", "code": "brasseries"],
                                         ["name" : "Brazilian", "code": "brazilian"],
                                         ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                                         ["name" : "British", "code": "british"],
                                         ["name" : "Buffets", "code": "buffets"],
                                         ["name" : "Bulgarian", "code": "bulgarian"],
                                         ["name" : "Burgers", "code": "burgers"],
                                         ["name" : "Burmese", "code": "burmese"],
                                         ["name" : "Cafes", "code": "cafes"],
                                         ["name" : "Cafeteria", "code": "cafeteria"],
                                         ["name" : "Cajun/Creole", "code": "cajun"],
                                         ["name" : "Cambodian", "code": "cambodian"],
                                         ["name" : "Canadian", "code": "New)"],
                                         ["name" : "Canteen", "code": "canteen"],
                                         ["name" : "Caribbean", "code": "caribbean"],
                                         ["name" : "Catalan", "code": "catalan"],
                                         ["name" : "Chech", "code": "chech"],
                                         ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                                         ["name" : "Chicken Shop", "code": "chickenshop"],
                                         ["name" : "Chicken Wings", "code": "chicken_wings"],
                                         ["name" : "Chilean", "code": "chilean"],
                                         ["name" : "Chinese", "code": "chinese"],
                                         ["name" : "Comfort Food", "code": "comfortfood"],
                                         ["name" : "Corsican", "code": "corsican"],
                                         ["name" : "Creperies", "code": "creperies"],
                                         ["name" : "Cuban", "code": "cuban"],
                                         ["name" : "Curry Sausage", "code": "currysausage"],
                                         ["name" : "Cypriot", "code": "cypriot"],
                                         ["name" : "Czech", "code": "czech"],
                                         ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                                         ["name" : "Danish", "code": "danish"],
                                         ["name" : "Delis", "code": "delis"],
                                         ["name" : "Diners", "code": "diners"],
                                         ["name" : "Dumplings", "code": "dumplings"],
                                         ["name" : "Eastern European", "code": "eastern_european"],
                                         ["name" : "Ethiopian", "code": "ethiopian"],
                                         ["name" : "Fast Food", "code": "hotdogs"],
                                         ["name" : "Filipino", "code": "filipino"],
                                         ["name" : "Fish & Chips", "code": "fishnchips"],
                                         ["name" : "Fondue", "code": "fondue"],
                                         ["name" : "Food Court", "code": "food_court"],
                                         ["name" : "Food Stands", "code": "foodstands"],
                                         ["name" : "French", "code": "french"],
                                         ["name" : "French Southwest", "code": "sud_ouest"],
                                         ["name" : "Galician", "code": "galician"],
                                         ["name" : "Gastropubs", "code": "gastropubs"],
                                         ["name" : "Georgian", "code": "georgian"],
                                         ["name" : "German", "code": "german"],
                                         ["name" : "Giblets", "code": "giblets"],
                                         ["name" : "Gluten-Free", "code": "gluten_free"],
                                         ["name" : "Greek", "code": "greek"],
                                         ["name" : "Halal", "code": "halal"],
                                         ["name" : "Hawaiian", "code": "hawaiian"],
                                         ["name" : "Heuriger", "code": "heuriger"],
                                         ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                                         ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                                         ["name" : "Hot Dogs", "code": "hotdog"],
                                         ["name" : "Hot Pot", "code": "hotpot"],
                                         ["name" : "Hungarian", "code": "hungarian"],
                                         ["name" : "Iberian", "code": "iberian"],
                                         ["name" : "Indian", "code": "indpak"],
                                         ["name" : "Indonesian", "code": "indonesian"],
                                         ["name" : "International", "code": "international"],
                                         ["name" : "Irish", "code": "irish"],
                                         ["name" : "Island Pub", "code": "island_pub"],
                                         ["name" : "Israeli", "code": "israeli"],
                                         ["name" : "Italian", "code": "italian"],
                                         ["name" : "Japanese", "code": "japanese"],
                                         ["name" : "Jewish", "code": "jewish"],
                                         ["name" : "Kebab", "code": "kebab"],
                                         ["name" : "Korean", "code": "korean"],
                                         ["name" : "Kosher", "code": "kosher"],
                                         ["name" : "Kurdish", "code": "kurdish"],
                                         ["name" : "Laos", "code": "laos"],
                                         ["name" : "Laotian", "code": "laotian"],
                                         ["name" : "Latin American", "code": "latin"],
                                         ["name" : "Live/Raw Food", "code": "raw_food"],
                                         ["name" : "Lyonnais", "code": "lyonnais"],
                                         ["name" : "Malaysian", "code": "malaysian"],
                                         ["name" : "Meatballs", "code": "meatballs"],
                                         ["name" : "Mediterranean", "code": "mediterranean"],
                                         ["name" : "Mexican", "code": "mexican"],
                                         ["name" : "Middle Eastern", "code": "mideastern"],
                                         ["name" : "Milk Bars", "code": "milkbars"],
                                         ["name" : "Modern Australian", "code": "modern_australian"],
                                         ["name" : "Modern European", "code": "modern_european"],
                                         ["name" : "Mongolian", "code": "mongolian"],
                                         ["name" : "Moroccan", "code": "moroccan"],
                                         ["name" : "New Zealand", "code": "newzealand"],
                                         ["name" : "Night Food", "code": "nightfood"],
                                         ["name" : "Norcinerie", "code": "norcinerie"],
                                         ["name" : "Open Sandwiches", "code": "opensandwiches"],
                                         ["name" : "Oriental", "code": "oriental"],
                                         ["name" : "Pakistani", "code": "pakistani"],
                                         ["name" : "Parent Cafes", "code": "eltern_cafes"],
                                         ["name" : "Parma", "code": "parma"],
                                         ["name" : "Persian/Iranian", "code": "persian"],
                                         ["name" : "Peruvian", "code": "peruvian"],
                                         ["name" : "Pita", "code": "pita"],
                                         ["name" : "Pizza", "code": "pizza"],
                                         ["name" : "Polish", "code": "polish"],
                                         ["name" : "Portuguese", "code": "portuguese"],
                                         ["name" : "Potatoes", "code": "potatoes"],
                                         ["name" : "Poutineries", "code": "poutineries"],
                                         ["name" : "Pub Food", "code": "pubfood"],
                                         ["name" : "Rice", "code": "riceshop"],
                                         ["name" : "Romanian", "code": "romanian"],
                                         ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                                         ["name" : "Rumanian", "code": "rumanian"],
                                         ["name" : "Russian", "code": "russian"],
                                         ["name" : "Salad", "code": "salad"],
                                         ["name" : "Sandwiches", "code": "sandwiches"],
                                         ["name" : "Scandinavian", "code": "scandinavian"],
                                         ["name" : "Scottish", "code": "scottish"],
                                         ["name" : "Seafood", "code": "seafood"],
                                         ["name" : "Serbo Croatian", "code": "serbocroatian"],
                                         ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                                         ["name" : "Singaporean", "code": "singaporean"],
                                         ["name" : "Slovakian", "code": "slovakian"],
                                         ["name" : "Soul Food", "code": "soulfood"],
                                         ["name" : "Soup", "code": "soup"],
                                         ["name" : "Southern", "code": "southern"],
                                         ["name" : "Spanish", "code": "spanish"],
                                         ["name" : "Steakhouses", "code": "steak"],
                                         ["name" : "Sushi Bars", "code": "sushi"],
                                         ["name" : "Swabian", "code": "swabian"],
                                         ["name" : "Swedish", "code": "swedish"],
                                         ["name" : "Swiss Food", "code": "swissfood"],
                                         ["name" : "Tabernas", "code": "tabernas"],
                                         ["name" : "Taiwanese", "code": "taiwanese"],
                                         ["name" : "Tapas Bars", "code": "tapas"],
                                         ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                                         ["name" : "Tex-Mex", "code": "tex-mex"],
                                         ["name" : "Thai", "code": "thai"],
                                         ["name" : "Traditional Norwegian", "code": "norwegian"],
                                         ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                                         ["name" : "Trattorie", "code": "trattorie"],
                                         ["name" : "Turkish", "code": "turkish"],
                                         ["name" : "Ukrainian", "code": "ukrainian"],
                                         ["name" : "Uzbek", "code": "uzbek"],
                                         ["name" : "Vegan", "code": "vegan"],
                                         ["name" : "Vegetarian", "code": "vegetarian"],
                                         ["name" : "Venison", "code": "venison"],
                                         ["name" : "Vietnamese", "code": "vietnamese"],
                                         ["name" : "Wok", "code": "wok"],
                                         ["name" : "Wraps", "code": "wraps"],
                                         ["name" : "Yugoslav", "code": "yugoslav"]];
}
