//
//  ViewController.swift
//  GB8Firebase
//
//  Created by Александр Арсенюк on 10.12.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let tarctor = tarctors[indexPath.row]
        cell?.textLabel?.text = tarctor.name + " " + tarctor.color.description
        return cell ?? UITableViewCell()
    }
    
}

class ViewController: UIViewController {
    
    var tarctors = [FirebaseTractor]()
    private let ref = Database.database(url: "https://gb8firebase-default-rtdb.europe-west1.firebasedatabase.app").reference(withPath: "tarctors")
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.observe(.value) { data in
            var tractors = [FirebaseTractor]()
            for child in data.children {
                if let snapshot = child as? DataSnapshot,
                   let tractor = FirebaseTractor(snapshot: snapshot) {
                    tractors.append(tractor)
                }
            }
            self.tarctors = tractors
            self.tableView.reloadData()
        }
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Erorr to logout")
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        let tractor = FirebaseTractor(name: "Firebase tractor", color: "yellow", model: 0)
        let tractorRef = self.ref.child(Date().hashValue.description)
        tractorRef.setValue(tractor.toDict())
    }
    
}

