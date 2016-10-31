//
//  TableViewController.swift
//  SwiggyDemo
//
//  Created by Lab kumar on 31/10/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var restaurantsList = [Restaurants]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var currentPageNumber: Int = 0
    var isFetchingData = false

    let RestaurantIdentifier = "RestaurantReuseIdentifier"
    let OutletIdentifier = "OutletReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.registerNib(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: RestaurantIdentifier)
        tableView.registerNib(UINib(nibName: "OutletTableViewCell", bundle: nil), forCellReuseIdentifier: OutletIdentifier)
        tableView.registerNib(UINib(nibName: "SectionView", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        
        tableView.separatorStyle = .None
        
        getDataForPageNumber(currentPageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurantsList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let data = restaurantsList[section]
        if data.selected {
            return data.chain?.count ?? 1
        }
        
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = restaurantsList[indexPath.section]
        
        let reuseIdentifier = data.selected ? OutletIdentifier : RestaurantIdentifier

        // Configure the cell...
        if !data.selected {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell
            cell.restaurantData = data
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! OutletTableViewCell
            cell.outletData = data.chain?[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let data = restaurantsList[section]
        
        return data.selected ? 100 : 5
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = restaurantsList[indexPath.section]
        
        data.selected = data.chain?.count > 0 && !data.selected
        reloadDataInSection(indexPath.section)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160  // beacause Row height in XIB is 158
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        UIView.performWithoutAnimation { 
            cell.layoutIfNeeded()
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let data = restaurantsList[section]
        
        guard let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as? SectionView where data.selected else {
            return nil
        }
        
        view.nameLabel.text = data.name
        view.contentView.backgroundColor = UIColor.blackColor()
        
        view.tapHandler = { [weak self] in
            let data = self?.restaurantsList[section]
            data?.selected = false
            self?.reloadDataInSection(section)
        }
        
        return view
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- Getting Data
    
    func reloadDataInSection (section: Int) {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        //tableView.reloadData()
        tableView.endUpdates()
    }
    
    func getDataForPageNumber (number: Int) {
        
        getDataFromURL("https://api.myjson.com/bins/ngcc?page=\(number)", completionHandler: { (success, result) in
            
        })
    }
    
    let requestor = BaseRequestor()
    
    func getDataFromURL (url: String, completionHandler: NetworkCompletionHandler?) {
        guard !isFetchingData else {
            return
        }
        
        isFetchingData = true
        showNextPageIndicator()
        requestor.makeGETRequestWithparameters(url, success: { [weak self] (result) in
            if let array = (result as? [String: AnyObject])?["restaurants"] {
                print(array)
                if let restaurants = Response(dictionary: result as! [String : AnyObject]).restaurants {
                    print(restaurants)
                    self?.restaurantsList.appendContentsOf(restaurants)
                    self?.isFetchingData = false
                    self?.hideNextPageIndicator()
                }
            }
        }) { (error) in
            //
        }
    }
    
    // MARK:- Scroll Delegate
    let scrollOffsetForEnd: CGFloat = 10.0
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height-scrollOffsetForEnd {
            print(" you reached end of the table")
            currentPageNumber += 1
            //showNextPageIndicator()
            getDataForPageNumber(currentPageNumber)
        }
    }
    
    func showNextPageIndicator () {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        let height = restaurantsList.count == 0 ? 6*scrollOffsetForEnd : 3*scrollOffsetForEnd
        view.frame = CGRectMake(0, 0, tableView.bounds.width, height)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        tableView.tableFooterView = view
    }
    
    func hideNextPageIndicator () {
        tableView.tableFooterView = nil
    }
}
