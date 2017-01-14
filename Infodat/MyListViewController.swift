//
//  MyListViewController.swift
//  Infodat
//
//  Created by Steven on 12/14/16.
//  Copyright © 2016 Nhuan Quang Company Limited. All rights reserved.
//

import UIKit

/**
 This class contains the list of data called from RESTful webservices.
 URL: https://alpha-api.app.net/stream/0/posts/stream/global
 */

class MyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, LibraryAPIProtocol {
    
    @IBOutlet var tableView: UITableView!
    var mainArray = [AnyObject]()
    var mainFilteredArray = [AnyObject]()
    var filterArray = ["All"]
    var currentFilterIndex = 0
    
    var myIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var myPickerView : UIPickerView?
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait ,UIInterfaceOrientationMask.portraitUpsideDown, UIInterfaceOrientationMask.landscape]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "My List"
        self.navigationItem.setHidesBackButton(true, animated:true);
        
//        self.setUpButtons()
        
        self.tableView.estimatedRowHeight = 138
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        let rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.handleFilter))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
        self.tableView.addSubview(myIndicator)
        myIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        myIndicator.startAnimating()
        
        let rect = CGRect(
            x:0,
            y:0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
        
        self.myPickerView = UIPickerView(frame:rect)
        self.myPickerView!.backgroundColor = UIColor.darkGray
        self.myPickerView!.clipsToBounds = true
        self.myPickerView!.layer.borderWidth = 1
        self.myPickerView!.dataSource = self
        self.myPickerView!.delegate = self
        self.navigationController?.view.addSubview(self.myPickerView!)
        
        self.myPickerView!.isHidden = true
        
        //load data
        LibraryAPI.shareLibraryAPI.delegate = self
        LibraryAPI.shareLibraryAPI.loadDataFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    override func viewDidLayoutSubviews () {
        
    }
    /**
     This method is called after we finish receiving responses from server
     
     - Parameter data: is AnyObject type which we get from json result
     
     - Returns: Void
     */
    func didFinishLoadData(data: AnyObject?) -> Void {
        self.mainArray = data as! [AnyObject]
        
        //sort main array
        self.mainArray.sort(by: {dict1,dict2 in
            let d1 = dict1["user"] as! [String:Any]
            let d2 = dict2["user"] as! [String:Any]
            
            guard let name1 = d1["name"] as? String
                else {
                    return false
            }
            guard let name2 = d2["name"] as? String
                else{
                    return false
            }
            
            return name1 < name2
        })
        
        self.reorganizeFilterData()
        
        myIndicator.stopAnimating()
        myIndicator.isHidden = true
        self.setupDataItem()
    }
    
    /**
     This method reorganize the data in UIPickerView after we distinct and sort from original data array from json result.
     
     - Returns: Reload data in picker view
     */
    func reorganizeFilterData () {
        //reorganize picker view data
        var tmpArray = self.mainArray.map() {dict -> String in
            let d = dict["user"] as! [String:Any]
            guard let name = d["name"] as? String
                else {
                    return "Unknown"
            }
            return name
        }
        
        tmpArray = tmpArray.distinct
        //sort filter array
        tmpArray.sort(by: { $0 < $1})
        
        for str in tmpArray {
            filterArray.append(str)
        }
        
        self.myPickerView?.reloadAllComponents()
    }
    
    func setupDataItem() {
        self.tableView.reloadData()
    }
    
    //MARK:    TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentFilterIndex == 0) {
            return self.mainArray.count
        }
        else {
            return self.mainFilteredArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DynamicTableViewCell
        
        let tmpArray : [AnyObject]
        
        if (currentFilterIndex == 0) {
            tmpArray = self.mainArray
        }
        else {
            tmpArray = self.mainFilteredArray
        }
        //extract data from json
        let dataDict = tmpArray[indexPath.row]
        let userDict = dataDict["user"] as! [String:Any]
        let avatarDict = userDict["avatar_image"] as! [String:Any]
        let imgUrl = avatarDict["url"]! as! String
        
        cell.imgView.imageFromServerURL(urlString: imgUrl)
        cell.titleLabel.text = userDict["name"] as? String
        cell.dateLabel.text = dataDict["created_at"] as? String
        cell.bodyLabel.text = dataDict["text"] as? String
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showCellDetail") {
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let dataDict : AnyObject
            if (currentFilterIndex == 0) {
                dataDict = self.mainArray[(indexPath?.row)!]
            }
            else {
                dataDict = self.mainFilteredArray[(indexPath?.row)!]
            }
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.dataDict = dataDict
            
        }
    }
    
    /**
     This method handle each time user select filter function.
     
     For example: when user selects "All", the table view will list all data. Or select "ABC", the table view will list all record with name field is "ABC".
     
     - Returns: Reload data in table view.
     */
    func handleFilter() -> Void {
        self.myPickerView?.isHidden = false
        self.myPickerView?.selectRow(currentFilterIndex, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.filterArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: self.filterArray[row] as String, attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentFilterIndex = row
        self.myPickerView?.isHidden = true
        
        self.filterByFilterIndex(filterIndex: currentFilterIndex)
        self.tableView.reloadData()
    }

    /**
     This method filters the data which matches with the name we selected in picker view.
     
     For example: when we select "All", the table view will list all data. Or select "ABC", the table view will list all record with name field is "ABC".
     
     - Parameter filterIndex: The current filter index in picker view selected.
     - Returns: Reload data in table view.
     */
    func filterByFilterIndex(filterIndex: Int) -> Void {
        let filterName = self.filterArray[currentFilterIndex]
        let tmpArray = self.mainArray.filter() { dict in
            let d = dict["user"] as! [String:Any]
            guard let name = d["name"] as? String
                else {
                    return filterName == "Unknown"
            }
            
            return name == filterName
        }
        
        self.mainFilteredArray = tmpArray
    }
}
