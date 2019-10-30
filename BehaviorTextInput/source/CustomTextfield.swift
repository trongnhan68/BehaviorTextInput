//
//  CustomTextfield.swift
//  ValidationTextField
//
//  Created by Nhan Nguyen Le Trong on 10/29/19.
//  Copyright © 2019 Nhan Nguyen Le Trong. All rights reserved.
//

import UIKit

protocol CustomTextfieldProtocol: class {

    func becomeFirstResponde()
    func resignFirstResponder()
}


class CustomTextfield: UITextField, UITextFieldDelegate {

    weak var customDelegate: CustomTextfieldProtocol?
    
    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }
    
    // MARK: Responder handling
    
    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        customDelegate?.becomeFirstResponde()
        return result
    }
    
    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        customDelegate?.resignFirstResponder()
        return result
    }

}
