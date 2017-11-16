

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating{

    @IBOutlet var tableV: UITableView!
    
    let arrayA = ["ac","ag","be","db","ne","db","cd","ba","df","ef"]
    var twiceDic: [String:[String]]!
    var twiceNames: [String]!
    var filteredArray = [String]()
    
    var searchCon: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pathA = Bundle.main.path(forResource: "Twice", ofType: "json")
        let dataA = try! Data(contentsOf: URL(fileURLWithPath: pathA!))
        self.twiceDic = try! JSONSerialization.jsonObject(with: dataA, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:[String]]
        self.twiceNames = Array(twiceDic.keys)
        
        
        self.searchCon = UISearchController(searchResultsController: nil)
        self.searchCon.searchResultsUpdater = self
        self.searchCon.dimsBackgroundDuringPresentation = false
        self.searchCon.searchBar.sizeToFit()
        self.tableV.tableHeaderView = self.searchCon.searchBar
        
        
        self.tableV.register(UITableViewCell.self, forCellReuseIdentifier: "Reuse")
        
        
        tableV.dataSource = self
        tableV.delegate = self
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.twiceNames
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.twiceNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.searchCon.isActive{
            return filteredArray.count
        }else{
            //return self.twiceNames.count
            let memberName = self.twiceNames[section]
            let spacArr = self.twiceDic[memberName]
            return spacArr!.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.twiceNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath)
        
        if self.searchCon.isActive{
            cell.textLabel?.text = filteredArray[indexPath.row]
        }else{
            
            let memberName = self.twiceNames[indexPath.section]
            let specArr = self.twiceDic[memberName]
            cell.textLabel?.text = specArr![indexPath.row]
        }
        
        
        return cell
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //print(searchController.searchBar.text!)
        filteredArray.removeAll(keepingCapacity: false)
        let predicateA = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let arrayF = (arrayA as NSArray).filtered(using: predicateA)
        filteredArray = arrayF as! [String]
        self.tableV.reloadData()
    }
    

       }




