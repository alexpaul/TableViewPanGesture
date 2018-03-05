//
//  ViewController.swift
//  TableViewPanGesture
//
//  Created by Alex Paul on 3/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import Fakery

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var companies = [String]()
    private var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collapseTableView()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panTableView))
        tableView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        tableView.dataSource = self
        
        let faker = Faker(locale: "nb-NO")

        for _ in 0...50 {
            companies.append(faker.company.name())
        }
    }
    
    @objc private func panTableView(gesture: UIPanGestureRecognizer) {
        print("panTableView: \(tableView.frame)")
        let translation = panGesture.translation(in: view)
        panGesture.view?.center = CGPoint(x: panGesture.view!.center.x, y: panGesture.view!.center.y + translation.y)
        panGesture.setTranslation(CGPoint.zero, in: view)
        if tableView.frame.origin.y <= 0.0 {
            tableView.frame = view.bounds
        }
    }
    
    @IBAction private func collapseTableView() {
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.frame = CGRect(x: 0,
                                     y: self.view.bounds.height * 0.75,
                                     width: self.view.bounds.width,
                                     height: self.view.bounds.height)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gestureRecognizerShouldBegin")
        print("tableview frame: \(tableView.frame)")
        if tableView.frame.origin.y <= 0.0 {
            return false
        }
        return true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = companies[indexPath.row]
        return cell
    }
}

