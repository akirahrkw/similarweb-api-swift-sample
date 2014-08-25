//
//  ViewController.swift
//  SimilarWebViewer
//
//  Created by Hirakawa Akira on 17/8/14.
//  Copyright (c) 2014 Hirakawa Akira. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    class var CellIdentifier : NSString {
        return "ListCell"
    }

    var tableView: UITableView?
    var array: Array<NSDictionary>?
    let apiKey = "API_KEY"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        var _array: Array<NSDictionary> = Array()
        _array.append(request("burpple.com", apikey: self.apiKey))
        _array.append(request("hungrygowhere.com", apikey: self.apiKey))
        _array.append(request("zomato.com", apikey: self.apiKey))
        _array.append(request("yelp.com", apikey: self.apiKey))
        _array.append(request("tabelog.com", apikey: self.apiKey))
        _array.sort({(v1: NSDictionary, v2: NSDictionary) -> Bool in
            var rank1 = v1.objectForKey("GlobalRank")?.intValue
            var rank2 = v2.objectForKey("GlobalRank")?.intValue
            return rank1 < rank2
        })
        self.array = _array
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: UITableViewDataSource methods
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.array!.count
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var dic:NSDictionary = self.array![indexPath.row]
        var cell:ListCell = self.tableView!.dequeueReusableCellWithIdentifier(ListViewController.CellIdentifier) as ListCell
        var rank:NSNumber = dic.objectForKey("GlobalRank") as NSNumber
        var name:String = dic.objectForKey("name") as String

        cell.ranking.text = rank.stringValue.rank() + ":"
        cell.name.text = name
        return cell
    }

    private
    func setupTableView() {
        var nib: UINib = UINib(nibName: ListViewController.CellIdentifier, bundle: nil)
        var _tableView = UITableView()
        _tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.registerNib(nib, forCellReuseIdentifier: ListViewController.CellIdentifier)

        self.tableView = _tableView
        self.view.addSubview(_tableView)

        var dic: NSDictionary = ["_tableView": _tableView]
        var constraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("|[_tableView]|", options: NSLayoutFormatOptions.AlignAllLeft , metrics: nil, views: dic)
        self.view.addConstraints(constraints)

        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[_tableView]|", options: NSLayoutFormatOptions.AlignAllBaseline , metrics: nil, views: dic)
        self.view.addConstraints(constraints)
    }

    func request(target: String, apikey: String) -> NSDictionary {
        var urlString: String = NSString(format: "http://api.similarweb.com/Site/%@/v1/traffic?Format=JSON&UserKey=%@", target, apikey)
        var url: NSURL = NSURL.URLWithString(urlString)
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        var urlResponse: NSURLResponse?
        var responseData :NSData = NSURLConnection.sendSynchronousRequest(request,returningResponse: &urlResponse, error: nil)!
        var result: NSString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
        //NSLog("%@", result)

        var json: NSMutableDictionary = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSMutableDictionary
        //NSLog("%@", json)

        json.setObject(target, forKey: "name")
        return json
    }
}

