//
//  DetailViewController.swift
//  Flickr
//
//  Created by Hemant Singh on 30/04/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var fullImageView: UIImageView!
    var item: Photo?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let thisItem = item,let urlString = thisItem.url, let thisUrl = URL(string: urlString) {
            self.title = thisItem.title
            DownloadManager.sharedManager.getImage(for: thisUrl) {[weak self] (url, image) in
             self?.fullImageView.image = image
            }
        }
        // Do any additional setup after loading the view.
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
