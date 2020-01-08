//
//  PhotosVC.swift
//  Virtual Tourist
//
//  Created by Enas Alrehaili on 2019-12-22.
//  Copyright © 2019 Enas Alrehaili. All rights reserved.
//

import MapKit
import UIKit
import CoreData

class PhotosVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionButton: UIBarButtonItem!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var pin: Pin!
    var pageNumber = 1
    var photosDeleted = false
    
    var context: NSManagedObjectContext {
        return DataController.sharedInstance.viewContext
    }
    
    var availablePhotos: Bool {
        return (fetchedResultsController.fetchedObjects?.count ?? 0) != 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
         self.textLabel.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchRequest.predicate  = NSPredicate(format: "pin == %@", pin)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            if availablePhotos {
                updateUI(processing: false)
                
            }else {
                 newCollectionButton(self)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    @IBAction func newCollectionButton(_ sender: Any) {
        updateUI(processing: true)
        if availablePhotos {
            photosDeleted = true
            for photo in fetchedResultsController.fetchedObjects! {
                context.delete(photo)
            }
            try?context.save()
            photosDeleted = false
        }
        FlickrAPI.getPhotosUrls(with: pin.coordinate, pageNumber: pageNumber) { (urls, error, errorMsg) in
            DispatchQueue.main.async {
                self.updateUI(processing: false)
                guard (error == nil) && (errorMsg == nil) else {
                    self.alert(title: "error", message: error?.localizedDescription ?? errorMsg)
                    return
                }
                guard let urls = urls, !urls.isEmpty else{
                    self.textLabel.isHidden = false
                    return
                    
                }
                for url in urls {
                    let photo = Photo(context: self.context)
                    photo.imageURL = url
                    photo.pin = self.pin
                }
                try? self.context.save()
            }
        }
        pageNumber+=1
    }
    
    func updateUI(processing: Bool){
        collectionView.isUserInteractionEnabled = !processing
        if processing{
            activityIndicator.isHidden = false
            collectionButton.title = ""
            activityIndicator.startAnimating()
        } else {
             activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            collectionButton.title = "New Collection"
       
        }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
           if let indexPath = indexPath, type == .delete && !photosDeleted {
               collectionView.deleteItems(at: [indexPath])
               return
           }
           if let indexPath = indexPath, type == .insert {
               collectionView.insertItems(at: [indexPath])
               return
           }
           
           if let newIndexPath = newIndexPath, let oldIndexPath = indexPath, type == .move {
               collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
               return
           }
           if type != .update {
               collectionView.reloadData()
           }
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = fetchedResultsController.object(at: indexPath)
        cell.imageView.setPhoto(photo)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          let photo = fetchedResultsController.object(at: indexPath)
        context.delete(photo)
        try? context.save()
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20) / 3
        return CGSize(width: width, height: width)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 10
    }
    
  
   
}
    
    
    
  
    
   


 
