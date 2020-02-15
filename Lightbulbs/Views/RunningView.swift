//
//  RunningView.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class RunningView: UIView {
    
    //view setup
    var resultsHeadLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura-Bold", size: 32).done()
        label.text = "Results!"
        return label
    }()
    
    var secondaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura", size: 22).done()
        label.text = "Average Unique Colours"
        return label
    }()
    
    var restartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: 0xDC4545)
        button.addCorners(10).done()
        button.setTitle("Restart", for: .normal)
        return button
    }()
    var loadingView = LoadingView()

    lazy var stackView: UIStackView = {
        let hStack = UIStackView()
        hStack.alignment = .fill
        hStack.axis = .horizontal
        hStack.spacing = 0
        hStack.distribution = .fillEqually
        for i in 0 ..< 2 {
            let newBar = GraphBarView()
            newBar.nameLabel.text = i == 0 ? "Actual" : "Expected"
            hStack.addArrangedSubview(newBar)
            graphBarViews.append(newBar)
        }
        return hStack
    }()
    
    //nested custom view to expand to the entire page
    lazy var detailedResults = DetailedResultsView()
    
    //keeps track of graphBarViews for access to change height constraint
    var graphBarViews: [GraphBarView] = []
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
        resultsHeadLabel.setSuperview(self)
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addHeight(withConstant: 40)
            .addTopSafe(constant: 15).done()
        
        restartButton.setSuperview(self)
            .addTrailing(constant: -10)
            .addHeight(withConstant: 30)
            .addWidth(withConstant: 80)
            .addTopSafe(constant: 20).done()
        
        secondaryLabel.setSuperview(self)
            .addLeading(constant: 20)
            .addHeight(withConstant: 30)
            .addTrailing(constant: -20)
            .addTop(anchor: resultsHeadLabel.bottomAnchor, constant: 10).done()
        
        stackView.setSuperview(self)
            .addTop(anchor: secondaryLabel.bottomAnchor, constant: 20)
            .addLeading(constant: 20)
            .addTrailing(constant: -20)
            .addHeight(withConstant: 200)
            .addCorners(20).done()
        
        detailedResults.setSuperview(self)
            .addTop(anchor: stackView.bottomAnchor, constant: 10)
            .addLeading(constant: 20).addTrailing(constant: -20)
            .addBottomSafe(constant: -10).addCorners(20).done()
        
        loadingView.setSuperview(self).addConstraints(padding: 0).done()
    }
}

//MARK: SwiftUI Preview
import SwiftUI



@available(iOS 13.0, *)
struct ControllerPreview3: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ControllerPreview3.ContainerView>) -> ControllerPreview3.ContainerView.UIViewControllerType {
            return SwiftUIViewController2()
        }
        
        func updateUIViewController(_ uiViewController: ControllerPreview3.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ControllerPreview3.ContainerView>) {
            
        }
    }
}

class SwiftUIViewController2: UIViewController {
    override func viewDidLoad() {
        self.view = RunningView()
    }
}
