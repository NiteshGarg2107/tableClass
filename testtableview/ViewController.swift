//
//  ViewController.swift
//  testtableview
//
//  Created by Nitesh Garg on 20/03/21.
//

import UIKit

class ViewController: UIViewController, ViewModelDelegate, UISearchBarDelegate {
  
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    var viewmodel: ViewModel!
    var tableData: [Dictionary<String, AnyObject>] = [Dictionary<String, AnyObject>]()
    var hiddenSections = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel = ViewModel(ServiceClass())
        viewmodel.delegate = self
        searchbar.delegate = self
        
        // Do any additional setup after loading the view.
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 300
        tableview.register(UINib(nibName: "cellClass", bundle: nil), forCellReuseIdentifier: "cell")
        viewmodel.getDataFromJasonFile()
    }
    
    func getSuccessData(resp: Response) {
        
    }
    
    func getSuccessDataFromJason(resp: [Dictionary<String, AnyObject>]) {
        tableData = resp
        tableview.reloadData()
    }
    
    func getFailure() {
        let lert = UIAlertController(title: "TableView", message: "Error", preferredStyle: .alert)
        let action = UIAlertAction(title: "Hi", style: .default) { (alert) in
            
        }
        lert.addAction(action)
        self.present(lert, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        viewmodel.getData(req: Request(key: "17173870-1354e798802153a0d6d7e564a", q: searchbar.text ?? "Rose", image_type: "photo"))
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.hiddenSections.contains(section) {
                return (self.tableData[section]["sub_category"] as? [AnyObject])?.count ?? 0
            }
            return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: cellClass = tableView.dequeueReusableCell(withIdentifier: "cell") as! cellClass
        cell.lbl.text = (((self.tableData[indexPath.section]["sub_category"]) as! [AnyObject])[indexPath.row] as! [String: String])["name"]
        cell.detailText.text = (((self.tableData[indexPath.section]["sub_category"]) as! [AnyObject])[indexPath.row] as! [String: String])["display_name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionButton = UIButton()
            sectionButton.setTitle(tableData[section]["name"] as? String,
                                   for: .normal)
        sectionButton.backgroundColor = .white
        sectionButton.setTitleColor(.black, for: .normal)
            sectionButton.tag = section
            
            sectionButton.addTarget(self,
                                    action: #selector(self.hideSection(sender:)),
                                    for: .touchUpInside)
            return sectionButton
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc
    private func hideSection(sender: UIButton) {
        if hiddenSections.contains(sender.tag) {
            hiddenSections.remove(sender.tag)
        } else {
            hiddenSections.insert(sender.tag)
        }
        tableview.beginUpdates()
        tableview.reloadSections([sender.tag], with: .automatic)
        tableview.endUpdates()
    }
}

