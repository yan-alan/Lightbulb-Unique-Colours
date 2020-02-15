//
//  InputSelectionView.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class InputSelectionView: UIView {
    //inner view setup
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura-Bold", size: 32).done()
        label.text = "Lightbulb Picking!"
        return label
    }()
    var lightBulbs: [ContentFitImageView] =  []
    lazy var stackView: UIStackView = {
        let hStack = UIStackView()
        hStack.alignment = .fill
        hStack.axis = .horizontal
        hStack.spacing = 1
        hStack.distribution = .fillEqually
        for i in 0 ..< 3 { //fills the horizontal stack view with 3 lightbulbs
            let newView = ContentFitImageView(image: UIImage(systemName: "lightbulb.fill"))
            newView.setImageColor(color: .black)
            lightBulbs.append(newView)
            hStack.addArrangedSubview(newView)
        }
        return hStack
    }()
    var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Run", for: .normal)
        button.addCorners(10).setColor(UIColor(hex: 0x587FFF)).done()
        return button
    }()
    //creates 4 input views, to take in 4 paramaters, total number of lights are calculated
    var numColourView = InputView(title: " Number Of Colours ", placeHolder: "# of colours?")
    var numPerColour = InputView(title: " Number Of Each Colour ",  placeHolder: "# of lightbulbs per color?")
    var numberOfBulbs = InputView(title: " Number Of Lightbulbs Drawn ",  placeHolder: "# of lightbulbs drawn?")
    var numberOfSimulationRuns = InputView(title: " Number of Simulation Runs ",  placeHolder: "# times simulation runs?")

    //requires autolayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView() //view setup
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() { //constraint work
        welcomeLabel.setSuperview(self)
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addTopSafe(constant: 15).done()
        
        stackView.setSuperview(self)
            .addTop(anchor: welcomeLabel.bottomAnchor, constant: 30)
            .addLeading(constant:30)
            .addTrailing(constant: -30)
            .addHeight(withConstant: 100).done()
        
        numColourView.setSuperview(self)
            .addTop(anchor: stackView.bottomAnchor, constant: 30)
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addHeight(withConstant: 40).done()
        
        numPerColour.setSuperview(self)
            .addTop(anchor: numColourView.bottomAnchor, constant: 20)
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addHeight(withConstant: 40).done()
        
        numberOfBulbs.setSuperview(self)
            .addTop(anchor: numPerColour.bottomAnchor, constant: 20)
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addHeight(withConstant: 40).done()
        
        numberOfSimulationRuns.setSuperview(self)
            .addTop(anchor: numberOfBulbs.bottomAnchor, constant: 20)
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addHeight(withConstant: 40).done()
        
        startButton.setSuperview(self)
        .addCenterX()
        .addHeight(withConstant: 40)
        .addWidth(withConstant: 100)
        .addBottomSafe(constant: -10).done()
        
        //Sets up timer to run light switching
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runLights), userInfo: nil, repeats: true)
    }
    var lightCounter = 0
    @objc func runLights() {
        lightBulbs.forEach({
            $0.setImageColor(color: .black)
        })
        lightBulbs[lightCounter].setImageColor(color: .yellow)
        
        lightCounter += 1
        
        if(lightCounter == 3) {
            lightCounter = 0
        }
    }
}

///Defines an input view with a border and a text field
class InputView: UIView {
    //view setup
    var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura", size: 15).done()
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    var textField: UITextField = {
        let textField = UITextField()

        textField.placeholder = "search for plants to add..."
        textField.text = ""
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.textAlignment = .left

        return textField
    }()
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    init(title: String, placeHolder: String) {
        self.init()
        textLabel.text = title
        textField.placeholder = placeHolder
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        //constraint and border work
        let searchView = UIView()
        searchView.setSuperview(self)
            .addConstraints(padding: 0)
            .addCorners(10).done()
        searchView.layer.borderWidth = 1.5
        searchView.layer.borderColor = UIColor.black.cgColor
        
        textLabel.setSuperview(self)
            .addCenterY(anchor: searchView.topAnchor)
            .addLeading(anchor: searchView.leadingAnchor, constant: 10).done()
        
        textField.setSuperview(searchView)
            .addConstraints(padding: 10)
            .done()
    }
}


//MARK: SwiftUI Preview
import SwiftUI



@available(iOS 13.0, *)
struct ControllerPreview2: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ControllerPreview2.ContainerView>) -> ControllerPreview2.ContainerView.UIViewControllerType {
            return SwiftUIViewController()
        }
        
        func updateUIViewController(_ uiViewController: ControllerPreview2.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ControllerPreview2.ContainerView>) {
            
        }
    }
}

class SwiftUIViewController: UIViewController {
    override func viewDidLoad() {
        self.view = InputSelectionView()
    }
}
