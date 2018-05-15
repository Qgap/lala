//
//  ViewController.swift
//  Weather
//
//  Created by gap on 2017/12/8.
//  Copyright © 2017年 gq. All rights reserved.
//

import UIKit

class MainController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    lazy var tableView = UITableView.init()
    
    lazy var toolView = UIView.init()
    lazy var contentView = UIScrollView.init()

    let dataArray = ["智能问答","查询天气","行政"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Weather"
                
        tableView = UITableView.init(frame: self.view.frame, style: UITableViewStyle.grouped)
        tableView.tableFooterView = UIView.init()
        tableView.tableHeaderView = UIView.init()
        tableView.estimatedRowHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    
    }

    
    //MARK:TableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        
        cell.textLabel?.text = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        var vc = UIViewController.init()
        
        switch indexPath.row {
        case 0:
            vc = UIViewController()
            break;
        case 1:
            vc = UIViewController()
            break;
        case 2:
            vc = UIViewController()
            break
        default:
            break;
        }
        
        vc.title = self.dataArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

