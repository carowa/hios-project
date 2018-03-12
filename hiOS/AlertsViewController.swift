//
//  AlertsViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    let alerts:[AlertItem] = Alerts.shared.getAlerts()
    var addedAlert:Bool = false
    var currency:Cryptocurrency? = nil
    var myIndex:Int = 0
    
    let alertTypeString:[String] = ["none", "Percent Change", "Price"]
    
    @IBOutlet weak var alertsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertsTableView.delegate = self
        alertsTableView.dataSource = self
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: populate only favorites and then all other currencies
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertsViewTableCell", for: indexPath) as! AlertsTableViewCell
        let currAlert = alerts[indexPath.row]
        guard let id = currAlert.currencyId else { return cell }
        cell.identifierLabel?.text = id
        let alertString = "\(alertTypeString[Int(currAlert.alertType)]) \(currAlert.inequality ?? "") \(String(format: "%.3f", Double(currAlert.alertValue)))"
        cell.alertTypeLabel?.text = alertString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            myIndex = indexPath.row
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let detailedController = segue.destination as! DetailedViewController
            detailedController.currency = currency
            detailedController.addedAlert = true
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload favorties table view data source after a segue
        alertsTableView.reloadData()
    }

}
