//
//  AlertsViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController {
    var addedAlert:Bool = false
    var currency:Cryptocurrency? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if addedAlert {
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: currency?.name, style: .done, target: self, action: #selector(goToDetailedView))
        }
        // Do any additional setup after loading the view.
    }
    
    @objc private func goToDetailedView() {
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let detailedController = segue.destination as! DetailedViewController
            detailedController.currency = currency
            detailedController.addedAlert = true
        }
    
    }

}
