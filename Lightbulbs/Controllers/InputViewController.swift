//
//  InputViewController.swift
//  Lightbulbs
//
//  Created by Alan Yan on 2020-02-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class InputViewController: UIViewController {
    //various variables to hold differnet elements of the UI/counters
    private var numColoursTextField: UITextField!
    private var numEachColourTextField: UITextField!
    private var numLightbulbsDrawnTextField: UITextField!
    private var numSimulationRunsTextField: UITextField!

    private var numColours, numEachColour, numLightbulbsDrawn, numSimulationRuns: Int?
    
    //tracks keyboard
    private var keyboardInPresentation = false

    private var lightbulbImageViews: [ContentFitImageView] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //for reset button, when view appears, text is null
        numColoursTextField.text = ""
        numEachColourTextField.text = ""
        numLightbulbsDrawnTextField.text = ""
        numSimulationRunsTextField.text = ""

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //sets up text field delegate for all 4 inputViews
        let newView = InputSelectionView()
        lightbulbImageViews = newView.lightBulbs
        numColoursTextField = newView.numColourView.textField
        numColoursTextField.delegate = self
        numEachColourTextField = newView.numPerColour.textField
        numEachColourTextField.delegate = self
        numLightbulbsDrawnTextField = newView.numberOfBulbs.textField
        numLightbulbsDrawnTextField.delegate = self
        numSimulationRunsTextField = newView.numberOfSimulationRuns.textField
        numSimulationRunsTextField.delegate = self
        
        //adds target function for the startButton
        newView.startButton.addTarget(self, action: #selector(pushToRunningScreen), for: .touchUpInside)
        self.view = newView
        
        //Observes for keyboard raising and not
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //pushes to the running screen
    @objc func pushToRunningScreen() {
        let pushVC = RunningViewController()
        if let numColours = numColours, let numEachColour = numEachColour, let numLightbulbsDrawn = numLightbulbsDrawn, let numberOfSimulations = numSimulationRuns {
            //error checking on the textfields occurs here
            if(numLightbulbsDrawn > numColours * numEachColour) {
                let alert = UIAlertController(title: "Too Many Lightbulb Draws", message: "Can't take more lightbulbs than there are in the box", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if(numColours <= 0 || numEachColour <= 0 || numLightbulbsDrawn <= 0 || numberOfSimulations <= 0) {
                let alert = UIAlertController(title: "Illegal Entry", message: "Entries cannot be less than zero", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if(numColours > 120 || numEachColour > 120 || numLightbulbsDrawn > 120 || numberOfSimulations > 120) {
                let alert = UIAlertController(title: "Illegal Entry", message: "Enter numbers less than 120", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
                //if everything is good then we present the pushVC
                pushVC.model = LightbulbParamaters(numColours: numColours, numEachColour: numEachColour, numOfChoices: numLightbulbsDrawn, numberOfSimulations: numberOfSimulations)
                self.navigationController?.pushViewController(pushVC, animated: true)
            }
        } else {
            //not all fields filled in
            let alert = UIAlertController(title: "Fill In All Required Entries", message: "1 or more entry boxes are not filled out ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension InputViewController: UITextFieldDelegate {
    //MARK: Text Field Interaction
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveAllTextFields()
    }
    @objc private func tappedOutside() {
        self.view.endEditing(true)
    }
    @objc private func keyboardWillShow(sender: NSNotification) {
        if(!keyboardInPresentation) {
            keyboardInPresentation = true
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    @objc private func keyboardWillHide(sender: NSNotification) {
        saveAllTextFields()
        keyboardInPresentation = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    private func saveAllTextFields() {
        if let text = numColoursTextField.text {
            numColours = Int(text)
        }
        if let text = numEachColourTextField.text {
            numEachColour = Int(text)
        }
        if let text = numLightbulbsDrawnTextField.text {
            numLightbulbsDrawn = Int(text)
        }
        if let text = numSimulationRunsTextField.text {
            numSimulationRuns = Int(text)
        }
    }
}

//MARK: SwiftUI Preview
import SwiftUI



@available(iOS 13.0, *)
struct ControllerPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ControllerPreview.ContainerView>) -> ControllerPreview.ContainerView.UIViewControllerType {
            return InputViewController()
        }
        
        func updateUIViewController(_ uiViewController: ControllerPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ControllerPreview.ContainerView>) {
            
        }
    }
}


extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
