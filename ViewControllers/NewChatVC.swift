//
//  NewChatVC.swift
//  ChatAppProject
//
//  Created by Admin on 16.06.2022.
//

import Foundation
import MessageKit
import Firebase
import UIKit

class NewChatViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
   
    public var completion: ((SearchResults) -> (Void))?
    private var results = [SearchResults]()
    private var users = [[String: String]]()
    private var fetch = false 
    
    let spiner: UIActivityIndicatorView = {
        var spiner = UIActivityIndicatorView()
        spiner.style = UIActivityIndicatorView.Style.medium
        return spiner
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search new contact..."
        return searchBar
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results..."
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
        view.addSubview(spiner)
       
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUIConstaints()
        
        spiner.center = self.view.center
        spiner.isHidden = true
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismisSelf))
        searchBar.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    @objc private func dismisSelf() {
        dismiss(animated: true)
    }
    
    //tableView stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "NewChatTableViewCell", bundle: nil), forCellReuseIdentifier: "NewChatTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatTableViewCell", for: indexPath) as! NewChatTableViewCell
        let model = results[indexPath.row]
        
        cell.configur(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetUserData = results[indexPath.row]

        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
        }
    }
    //SearchBar config
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty  else { return }
       
       searchBar.resignFirstResponder()
       
       results.removeAll()
       spiner.isHidden = false
       spiner.startAnimating()
       searchUsers(text)
    }
    private func searchUsers(_ query: String) {
        //check if array has firebase result
        if fetch {
            filterUsers(with: query)
        }
        else {
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.fetch = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                    case .failure(let error):
                    print("Failed to get usres: \(error)")
                }
            })
        }
    }
    
    private func filterUsers(with term: String) {
       
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, fetch  else{ return }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        self.spiner.isHidden = true
          let results: [SearchResults] = users.filter({
                guard let email = $0["email"], email != safeEmail else {
                    return false
                }

                guard let name = $0["name"]?.lowercased() else {
                    return false
                }

                return name.hasPrefix(term.lowercased())
            }).compactMap({

                guard let email = $0["email"],
                    let name = $0["name"] else {
                    return nil
                }

                return SearchResults(email: email, name: name)
        })
        self.results = results
        print(results)
        updateUI()
    }
    
    private func updateUI() {
        if results.isEmpty {
            noResultsLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noResultsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func setupUIConstaints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            noResultsLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            noResultsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
            ])
    }
}
