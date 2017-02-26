//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    var searchBar: UISearchBar!
    
    var businesses: [Business]!
    let defaults = UserDefaults.standard


    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload businessview")
        initView()
        initSettings()
        
        Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()

//                for business in businesses {
//                    print("--------------------------------")
//                    print(business.name!)
//                    print(business.address!)
//                }
                
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let filterViewController = navigation.topViewController as! FilterViewController
        filterViewController.delegate = self
    }

}

extension BusinessesViewController: UITableViewDelegate,UITableViewDataSource,FilterViewControllerDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if businesses == nil {
            return 0
        }else{
            return businesses.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    func FilterViewController(_ filterView: FilterViewController, didUpdateFilter filters: [String], dealsState: Bool, distanceState: Int, sortState: Int) {
        print("apply filter: \(filters)")
        let radius = distanceState * 8046
        var yelpSort = sortState
        
        if yelpSort == 0 {
            yelpSort = sortState - 1
        }
        Business.search(with: "",distance: radius, sort: YelpSortMode(rawValue: yelpSort), categories: filters, deals: dealsState){(businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
    }
}

extension BusinessesViewController: UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Business.search(with: searchBar.text!){(businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Business.search(with: searchBar.text!){(businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
    }
}

extension BusinessesViewController{
    func initSettings() {
        if (defaults.bool(forKey: "Yelp.Filter.Deals") == nil) || (defaults.integer(forKey: "Yelp.Filter.Distance") == nil) || (defaults.integer(forKey: "Yelp.Filter.Sort") == nil) || (defaults.object(forKey: "Yelp.Filter.Categories") == nil){
            print("init User defaults:")
            let categories = [Int:Bool]()
            
            defaults.set(false, forKey: "Yelp.Filter.Deals")
            defaults.set(0, forKey: "Yelp.Filter.Distance")
            defaults.set(0, forKey: "Yelp.Filter.Sort")
            let data = NSKeyedArchiver.archivedData(withRootObject: categories)
            defaults.set(data, forKey: "Yelp.Filter.Categories")
        }

    }
    func initView() {
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
    }

}
