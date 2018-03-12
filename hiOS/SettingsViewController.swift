//
//  SettingsViewController.swift
//  hiOS
//
//  Created by Keertana Chandar on 3/2/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let availableSettings = ["Manage Favorites", "View Alerts"]
    private let settingsImages = ["icons8-alarm-50", "icons8-maintenance-50"]
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableSettings.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "showAddFavoritesSegue", sender: self)
        } else {
            performSegue(withIdentifier: "showViewAlertsSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        // Add the arrow to the right
        cell.accessoryType = .disclosureIndicator
        cell.settingLabel.text = availableSettings[indexPath.row]
        cell.settingicon.image = UIImage.init(named: settingsImages[indexPath.row])
        return cell
    }
    
    
}

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingicon: UIImageView!
}
