//
//  SettingsViewController.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView! {
        didSet {
            settingsTableView.dataSource = self
            settingsTableView.delegate = self
        }
    }
    
    var presenter: SettingsViewOutput!
    
    deinit {
        print("SettingsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingsViewController init")
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}
