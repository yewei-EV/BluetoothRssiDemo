//
//  MapView.swift
//  BabyBluetoothAppDemo
//
//  Created by Alina Li on 2018-03-04.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

import UIKit

class MapView: UIView {
    
    private let personImg: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "person_point"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // constraint specifying where the person image should be
    private lazy var personXConstraint: NSLayoutConstraint = {
        let safeView = self.safeAreaLayoutGuide
        let anchor = self.personImg.centerXAnchor.constraint(equalTo: safeView.centerXAnchor, constant: 0)
        return anchor
    }()
    private lazy var personYConstraint: NSLayoutConstraint = {
        let safeView = self.safeAreaLayoutGuide
        let anchor = self.personImg.centerYAnchor.constraint(equalTo: safeView.centerYAnchor, constant: 0)
        return anchor
    }()
    
    // x, y offsets from centre of screen of person image
    // update these two variables to change the location of image
    public var personXOffset: CGFloat! {
        didSet {
            self.personXConstraint.constant = self.personXOffset
        }
    }
    public var personYOffset: CGFloat! {
        didSet {
//            self.personYConstraint.isActive = false
            self.personYConstraint.constant = self.personYOffset
//            self.personYConstraint.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(personImg)
        personXConstraint.isActive = true
        personYConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // comment out this function then image will not move upon screen touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            personXOffset = position.x - self.frame.width / 2
            personYOffset = position.y - self.frame.height / 2
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
