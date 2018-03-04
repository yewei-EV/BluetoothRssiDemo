//
//  MovingPointViewController.swift
//  BabyBluetoothAppDemo
//
//  Created by Alina Li on 2018-03-04.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

import UIKit

@objc class MovingPointViewController: UIViewController {
    let mapView = MapView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: dispatch another thread
        
        let safeView = view.safeAreaLayoutGuide
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: safeView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: safeView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: safeView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: safeView.trailingAnchor).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if var xOffset = mapView.personXOffset, var yOffset = mapView.personYOffset {
            xOffset = xOffset > 0 ? xOffset : -xOffset
            yOffset = yOffset > 0 ? yOffset : -yOffset
            let xRatio = xOffset / size.height
            let yRatio = yOffset / size.width
            xOffset = mapView.personXOffset > 0 ? size.width * xRatio : -size.width * xRatio
            yOffset = mapView.personYOffset > 0 ? size.height * yRatio : -size.height * yRatio
            mapView.personXOffset = xOffset
            mapView.personYOffset = yOffset
        }
//        if UIDevice.current.orientation.isLandscape {
//
//        } else {
//
//        }
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
