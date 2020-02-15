//
//  DetailedResultsView.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class DetailedResultsView: UIView {
    
    var isPresented = false {
        didSet {
            //work to restore constraints of the detailed results view when dismissed
            if(!isPresented) {
                lightImageView.userDefinedConstraintDict["height"]?.constant = 500
                topLeftLabel.text = "More Details"
                dismissButton.isHidden = true
                resultsCollection.userDefinedConstraintDict["top"]?.isActive = false
                resultsCollection.userDefinedConstraintDict["bottom"]?.isActive = false
                resultsCollection.userDefinedConstraintDict["leading"]?.isActive = false
                resultsCollection.userDefinedConstraintDict["trailing"]?.isActive = false
                bottomLeftLabel.userDefinedConstraintDict["bottom"]?.isActive = false
                bottomLeftLabel.text = "Tap To View More"
                bottomLeftLabel.addBottom(constant: -10).done()
            }
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    //view setup
    var dismissButton: UIButton = {
        let button = UIButton()
        button.addCorners(20).setColor(.white).done()
        let down = UIImage(systemName: "chevron.down")!
        let downImage = down.withTintColor(.gray, renderingMode: .alwaysOriginal)
        button.setImage(downImage, for: .normal)
        button.isHidden = true
        return button
    }()
    
    var lightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundBulbs")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var topLeftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura-Bold", size: 30).done()
        label.text = "More Details"
        return label
    }()
    var secondBottomLeftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura", size: 18).done()
        label.textColor = .white
        label.text = "Lights:"
        return label
    }()
    var bottomLeftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura", size: 22).done()
        label.text = "Click to View More"
        return label
    }()
    
    var resultsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var colouredLights: [ContentFitImageView] = []
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
    override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .white
      setupView()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        //constraint setup
        lightImageView.setSuperview(self)
            .addTop()
            .addLeading()
            .addTrailing()
            .addHeight(withConstant: 500).done()
        
        dismissButton.setSuperview(self)
            .addTopSafe(constant: 20)
            .addTrailing(constant: -20)
            .addWidth(withConstant: 40)
            .addHeight(withConstant: 40).done()
        
        topLeftLabel.setSuperview(self)
            .addTopSafe(constant: 20)
            .addLeading(constant: 20)
            .addHeight(withConstant: 40).done()
        
        bottomLeftLabel.setSuperview(self)
            .addBottom(constant: -10)
            .addLeading(constant: 20)
            .addHeight(withConstant: 30).done()
        
        secondBottomLeftLabel.setSuperview(self)
            .addBottom(anchor: bottomLeftLabel.topAnchor, constant: -10)
            .addLeading(constant: 20)
            .addHeight(withConstant: 30).done()
        
        resultsCollection.setSuperview(self).done()
    }
    
    //creates n number of lights in the detailedResultsView, if > 15, created 15 lights of random colour to represent average
    func drawColoredLights(n: Int) {
        var num = n
        if(n > 14) {
            num = 14
        }
        let middle = num/2
        for i in 0 ..< num {
            let image = ContentFitImageView(image: UIImage(systemName: "lightbulb.fill"))
            image.setImageColor(color: .random)
            image.setSuperview(self)
                .addTop(anchor: topLeftLabel.bottomAnchor, constant: 10)
                .addBottom(anchor: secondBottomLeftLabel.topAnchor, constant: -10)
                .addWidth(withConstant: 150)
                .addCenterX(constant: CGFloat((i-middle)*20))
                .done()
            colouredLights.append(image)
        }
    }
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
