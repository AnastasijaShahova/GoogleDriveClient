//
//  FilesInfoTableViewController.swift
//  GoogleDrive
//
//  Created by Шахова Анастасия on 25.11.2023.
//

import UIKit
import GoogleAPIClientForREST

final class FilesInfoViewController: UIViewController {
    
    var tableView: UITableView!
    private var activityIndicator = UIActivityIndicatorView()
    
    var files = [GTLRDrive_File]()
    let service = GTLRDriveService()
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupActivityIndicator()
        fetchFromDrive()
    }
    
    @objc private func logoutButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - SetupConstraints
extension FilesInfoViewController {
    
    private func setupTableView() {
        navigationItem.title = "GoogleDrive"
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .white
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        view.addSubview(tableView)
        
        tableView.register(FileInfoTableViewCell.self, forCellReuseIdentifier: fileCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "house")!,
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
    }
    
    private func setupActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

//MARK: - LoadData
extension FilesInfoViewController {
    private func fetchFromDrive(_ strSearchText: String = "") {
        let drive = FileService(service)
        activityIndicator.startAnimating()
        
        drive.listAllFiles(strSearchText, token: token) { [weak self] (files, pageToken, error) in
            if let arrFiles = files {
                pageToken != nil ? (self?.files += arrFiles) :  (self?.files = arrFiles)
                self?.token = pageToken
                self?.activityIndicator.stopAnimating()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                AlertManager.showBasicAlert(on: self!, title: "Error", message: error?.localizedDescription ?? "")
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension FilesInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: fileCellIdentifier, for: indexPath)
        if let fileCell = cell as? FileInfoTableViewCell {
            fileCell.configureCell(files[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(files[indexPath.row])
        
        if let path = files[indexPath.row].webViewLink {
            let url = URL(string: path)!
            
            let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private let fileCellIdentifier = "FileInfoTableViewCell"
