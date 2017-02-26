//
//  FilterViewController.swift
//  
//
//  Created by Linh Le on 2/22/17.
//
//

import UIKit


@objc protocol FilterViewControllerDelegate{
    @objc optional func FilterViewController(_ filterView: FilterViewController, didUpdateFilter filters: [String], dealsState: Bool, distanceState: Int,sortState: Int)
}

class FilterViewController: UIViewController {

    let categories: [[String: String]] = CategoryList.category
    
    var categoryState = [Int:Bool]()
    var dealsState = false
    var distanceState = 0 //auto
    var sortState = 0 //auto
    var distanceValue = "auto"
    var sortValue = "auto"
    var distanceShowState = false
    var sortbyShowState = false
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FilterViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadSetting()
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        print("viewDidAppear")
        loadSetting()
        tableView.reloadData()
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        print("--------------onSave------------------")
        print(dealsState)
        print(CategoryList.distance[distanceState])
        print(CategoryList.sortby[sortState])
        print(categoryState)
        print(distanceValue)
        print(sortValue)
        print("----------------End onsave----------------")
        var filters = [String]()
        for (row,isSelected) in categoryState {
            if isSelected{
                filters.append(categories[row]["code"]!)
            }
        }
        
        if filters.count<=0 {
            filters = [""]
        }
        delegate.FilterViewController!(self, didUpdateFilter: filters, dealsState: dealsState, distanceState: distanceState,sortState: sortState)

        saveSettings()
        dismiss(animated: true, completion: nil)
    }
    
}
extension FilterViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = nameOfSection(section)

        switch sectionName {
        case "Dealing":
            return 1
        case "Distance":
            return 6
        case "Sort by":
            return 4
        case "Category":
            return categories.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nameOfSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionName = nameOfSection(section)

        switch sectionName {
        case "Dealing":
            return 61.0
        case "Distance":
            return 61.0
        case "Sort by":
            return 61.0
        case "Category":
            return 61.0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionName = nameOfSection(indexPath.section)
        
        switch sectionName {
        case "Dealing":
            return 40
        case "Distance":
            if indexPath.row == 0{
                return 40
            }else{
                if distanceShowState{
                    return 40
                }
                return 0
            }
            
        case "Sort by":
            if indexPath.row == 0{
                return 40
            }else{
                if sortbyShowState{
                    return 40
                }
                return 0
            }
            
        case "Category":
            return 40
        default:
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionName = nameOfSection(indexPath.section)

        switch sectionName {
        case "Dealing":
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
            cell.titleLabel.text = "Offering a deal"
            cell.switchButton.isOn = dealsState 
            cell.delegate = self
            return cell
        case "Distance":
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell") as! DropdownCell
                distanceValue = CategoryList.distance[distanceState]
                cell.titleLabel.text = distanceValue
                cell.delegate = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell") as! SelectionCell
                if indexPath.row == distanceState{
                    cell.selectButton.setImage(#imageLiteral(resourceName: "switchIconClicked"), for: .normal)
                    
                }else{
                    cell.selectButton.setImage(#imageLiteral(resourceName: "switchIcon"), for: .normal)
                }

                cell.titleLabel.text = CategoryList.distance[indexPath.row]
                cell.delegate = self
                return cell
            }

        case "Sort by":
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell") as! DropdownCell
                sortValue = CategoryList.sortby[sortState]
                cell.titleLabel.text = sortValue
                cell.delegate = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell") as! SelectionCell
                if indexPath.row == sortState{
                    cell.selectButton.setImage(#imageLiteral(resourceName: "switchIconClicked"), for: .normal)
                    
                }else{
                    cell.selectButton.setImage(#imageLiteral(resourceName: "switchIcon"), for: .normal)
                }
                cell.titleLabel.text = CategoryList.sortby[indexPath.row]
                cell.delegate = self
                return cell
            }
            
        case "Category":
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
            cell.titleLabel.text = categories[indexPath.row]["name"]
            cell.switchButton.isOn = categoryState[indexPath.row] ?? false
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell

            
            return cell
        }
    }
}
extension FilterViewController: SwitchCellDelegate,SelectionCellDelegate,DropdownCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let ip = tableView.indexPath(for: switchCell)
        let section = ip?.section
        let sectionName = nameOfSection(section!)
        
        switch sectionName {
        case "Dealing":
            dealsState = value
            break
        case "Distance": break
        case "Sort by": break
        case "Category":
            categoryState[(ip?.row)!] = value
            break
        default:
            break
        }
    }
    
    func selectionCell(selectionCell: SelectionCell, didChangeValue value: Bool) {

        let ip = tableView.indexPath(for: selectionCell)
        let section = ip?.section
        let sectionName = nameOfSection(section!)
        switch sectionName {
        case "Dealing": break
        case "Distance":
            distanceState =  (ip?.row)!
            distanceShowState = !distanceShowState
            distanceValue = CategoryList.distance[distanceState]
            break
        case "Sort by":
            sortState = (ip?.row)!
            sortbyShowState = !sortbyShowState
            sortValue = CategoryList.distance[sortState]
            break
        case "Category": break
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    func dropdownCell(dropdownCell: DropdownCell, didChangeValue value: Bool) {
        print("take dropdownCell delegate")
        let ip = tableView.indexPath(for: dropdownCell)
        let section = ip?.section
        let sectionName = nameOfSection(section!)
        switch sectionName {
        case "Dealing": break
        case "Distance":
            distanceShowState = value
            distanceValue = CategoryList.distance[distanceState]
            break
        case "Sort by":
            sortbyShowState = value
            sortValue = CategoryList.distance[sortState]
            break
        case "Category": break
        default:
            break
        }
        self.tableView.reloadData()
    }
}
extension FilterViewController{
    func nameOfSection(_ section: Int) -> String{
        switch section {
        case 0:
            return "Dealing"
        case 1:
            return "Distance"
        case 2:
            return "Sort by"
        default:
            return "Category"
        }
    }
    func loadSetting(){
        dealsState = defaults.bool(forKey: "Yelp.Filter.Deals") 
        distanceState = defaults.integer(forKey: "Yelp.Filter.Distance")
        sortState = defaults.integer(forKey: "Yelp.Filter.Sort") 
        categoryState = (defaults.object(forKey: "Yelp.Filter.Categories") as? [Int:Bool]) ?? [Int:Bool]()
        
        distanceValue = CategoryList.distance[distanceState]
        sortValue = CategoryList.sortby[sortState]
        print(distanceValue)
        print(sortValue)
    }
    func saveSettings(){
        defaults.set(dealsState, forKey: "Yelp.Filter.Deals")
        defaults.set(distanceState, forKey: "Yelp.Filter.Distance")
        defaults.set(sortState, forKey: "Yelp.Filter.Sort")
        let data = NSKeyedArchiver.archivedData(withRootObject: categoryState)
        defaults.set(data, forKey: "Yelp.Filter.Categories")
    }
}
