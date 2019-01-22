//
//  HistoryViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2019-01-18.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var pastFutureSegControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    @IBAction func pastFutureSegCPressed(_ sender: UISegmentedControl) {
        
        print(pastFutureSegControl.selectedSegmentIndex)
        
        if pastFutureSegControl.selectedSegmentIndex == 1 {
        view.backgroundColor = .red
        } else {
            view.backgroundColor = .black
        }
    }
    

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCellTableViewCell
        cell.testLabel?.text = "test"
        return cell
    }
    
    
    
    
    
    
}