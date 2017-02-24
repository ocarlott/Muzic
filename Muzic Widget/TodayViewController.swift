//
//  TodayViewController.swift
//  Muzic Widget
//
//  Created by Michael Ngo on 2/19/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import NotificationCenter
import MuzicFramework
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellId = "cellId"
    
    let defaults = UserDefaults(suiteName: "group.appdev")
    
    let DOCUMENT_DIR_URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.appdev")!
    
    var medias = [Item]()
    
    var maxHeight = 110
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataController = DataController()
        context = dataController.managedObjectContext
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: cellId)
        do {
            for path in try FileManager.default.contentsOfDirectory(atPath: DOCUMENT_DIR_URL.path) {
                print(path)
            }
        } catch let err {
            print(err)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchFiles()
        if medias.count > 3 {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            let rows = Int(medias.count / 3)
            self.maxHeight = 20 + 90 * rows + 15 * (rows - 1)
        } else {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
        }
        collectionView.reloadData()
    }
    
    func searchFiles() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorited == %@", NSNumber(booleanLiteral: true))
        do {
            if let results = try context?.fetch(fetchRequest) {
                medias = results
            }
        } catch {
            print("Cannot fetch favorite items")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize.height = 110
        } else {
            self.preferredContentSize.height = CGFloat(maxHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteCell
        cell.setupViews(media: medias[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
