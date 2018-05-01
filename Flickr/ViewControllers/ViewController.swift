//
//  ViewController.swift
//  Flickr
//
//  Created by Hemant Singh on 30/04/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let downloader: ImageDownloader = DownloadManager.sharedManager
    let disposeBag = DisposeBag()
    fileprivate var gridCount: CGFloat = 0.48
    fileprivate var currentPage = 0
    fileprivate var hasMore = true
    fileprivate var searchText: String?
    var selectedImage: UIImage?
    private var selectedFrame : CGRect?
    private var customInteractor : CustomInteractor?
    var searchController : UISearchController!
    var items: [Photo] = [Photo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerNibs(nibNames: ["CharacterViewCell"])
        self.searchController = UISearchController(searchResultsController:  nil)
        self.navigationController?.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        
        self.definesPresentationContext = true
        self.searchText = "Himalaya"
        self.searchPhotos(completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationItem.hidesSearchBarWhenScrolling = false
        
    }

    func searchPhotos(completion: ((_ success: Bool) -> Void)?) -> Void {
        guard let searchText = searchText else { return }
        PhotoManager.searchPhotos(forQuery: searchText, page: currentPage, disposeBag: disposeBag, completion: { [weak self] photos in
            if photos.count == 0 { self?.hasMore = false }
            if self?.currentPage == 0 {
                self?.items.removeAll()
            }
            self?.items.append(contentsOf: photos)
            self?.collectionView?.reloadData()
            completion?(true)
        })
        
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        items.removeAll()
        collectionView.reloadData()
        searchPhotos(completion: { success in
            if success {
                searchBar.text = nil
            }
        })
    }
    func updateSearchResults(for searchController: UISearchController) {
        collectionView.reloadData()
    }
    @IBAction func gridAction(_ sender: UIBarButtonItem) {
        let actionSheetController = UIAlertController(title: "Select grid count", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        [(2, 0.48),(3, 0.31),(4, 0.23)].forEach { (gridCount) in
            let gridActionButton = UIAlertAction(title: gridCount.0.description, style: .default) { action -> Void in
                self.gridCount = CGFloat(gridCount.1)
                self.collectionView.reloadData()
            }
            actionSheetController.addAction(gridActionButton)
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        items.removeAll()
        collectionView.reloadData()
        downloader.clearCache()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail", let item = sender as? Photo, let detailVC = segue.destination as? DetailViewController {
            detailVC.item = item
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return hasMore ? 2 : 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? items.count : 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterViewCell", for: indexPath) as! PhotoCell
            return cell
        default:
            if hasMore {
                currentPage = currentPage + 1
                searchPhotos(completion: nil)
            }
            return collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PhotoCell, let item = items.safe[indexPath.item], let urlString = item.url, let url = URL(string: urlString) {
            cell.characterImageView.image = nil
            downloader.getImage(for: url) { [weak cell] (thisURL, thisImage) in
                if url.absoluteString == thisURL?.absoluteString {
                    cell?.characterImageView.image = thisImage
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let item = items.safe[indexPath.item],let urlString = item.url, let url = URL(string: urlString) {
            downloader.decreasePriority(url: url)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell, let image = cell.characterImageView.image, let item = items.safe[indexPath.item] {
            self.selectedImage = image
            let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
            selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
            self.performSegue(withIdentifier: "Detail", sender: item)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width * gridCount, height: collectionView.frame.width * gridCount)
        default:
            return CGSize(width: collectionView.frame.width, height: 60)
        }
        
    }
}
extension ViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = self.selectedFrame else { return nil }
        guard let image = self.selectedImage else { return nil }
        
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return CustomAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: image)
        default:
            return CustomAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: false, originFrame: frame, image: image)
        }
    }

}

