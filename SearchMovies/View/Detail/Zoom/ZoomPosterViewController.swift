//
//  ZoomPosterViewController.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 04/03/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit

class ZoomPosterViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    var poster: UIImage?
    var imageScrollView: ImageScrollView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Initialize imageScrollView and adding it to viewControllers view
        self.imageScrollView = ImageScrollView(frame: self.view.bounds)
        
        self.view.addSubview(self.imageScrollView)
        self.layoutImageScrollView()
        
        //2. Get image
        //        let imagePath = Bundle.main.path(forResource: "225H", ofType: "jpg")!
        //        let image = UIImage(contentsOfFile: imagePath)!
        guard let image = poster else { return }
        
        //3. Ask imageScrollView to show image
        self.imageScrollView.display(image)
        
        //4. Adding closeButton to viewControllers view
        closeButton.roundView()
        self.view.addSubview(closeButton)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(hideCloseButton(_:)))
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)
        singleTap.require(toFail: imageScrollView.zoomingTap)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.restoreStatesForRotation(in: size)
    }
    
    func restoreStatesForRotation(in bounds: CGRect) {
        // recalculate contentSize based on current orientation
        let restorePoint = imageScrollView.pointToCenterAfterRotation()
        let restoreScale = imageScrollView.scaleToRestoreAfterRotation()
        imageScrollView.frame = bounds
        imageScrollView.setMaxMinZoomScaleForCurrentBounds()
        imageScrollView.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
    }
    
    func restoreStatesForRotation(in size: CGSize) {
        var bounds = self.view.bounds
        if bounds.size != size {
            bounds.size = size
            self.restoreStatesForRotation(in: bounds)
        }
    }
    
    func layoutImageScrollView() {
        self.imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: self.imageScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: self.imageScrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: self.imageScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self.imageScrollView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([top, left, bottom, right])
    }
    
    // MARK: - Actions
    @IBAction func closeActionButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideCloseButton(_ sender: UITapGestureRecognizer) {
        closeButton.alpha = closeButton.alpha == 1 ? 0 : 1
    }    
}
