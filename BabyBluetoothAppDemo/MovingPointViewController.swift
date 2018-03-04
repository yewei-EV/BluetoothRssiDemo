//
//  MovingPointViewController.swift
//  BabyBluetoothAppDemo
//
//  Created by Alina Li on 2018-03-04.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

import UIKit

@objc class MovingPointViewController: UIViewController {
    
    let personImg: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "person_point"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var personX: CGFloat! {
        didSet {
            personXConstraint.isActive = false
            personXConstraint.constant = personX
            personXConstraint.isActive = true
        }
    }
    var personY: CGFloat! {
        didSet {
            personYConstraint.isActive = false
            personYConstraint.constant = personY
            personYConstraint.isActive = true
        }
    }
    
    lazy var personXConstraint: NSLayoutConstraint = {
        let safeView = self.view.safeAreaLayoutGuide
        let anchor = self.personImg.centerXAnchor.constraint(equalTo: safeView.centerXAnchor, constant: 0)
        return anchor
    }()
    lazy var personYConstraint: NSLayoutConstraint = {
        let safeView = self.view.safeAreaLayoutGuide
        let anchor = self.personImg.centerYAnchor.constraint(equalTo: safeView.centerYAnchor, constant: 0)
        return anchor
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(personImg)
        personXConstraint.isActive = true
        personYConstraint.isActive = true
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
