//
//  ValidationTextfield.swift
//  ValidationTextField
//
//  Created by Nhan Nguyen Le Trong on 10/28/19.
//  Copyright © 2019 Nhan Nguyen Le Trong. All rights reserved.
//

import UIKit

class NibView: UIView {
    
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
}

private extension NibView {
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        view.frame = bounds
        view.backgroundColor = .clear
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view!]))
    }
}

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

enum ValidationTextFieldState: Int {
    case normal = 0
    case normalActive
    case valid
    case error
}

enum TextfieldValidation {
    
    case valid(String?) // action title
    case invalid(String?, String?) // (error message, action title)
    
    var errorMessage: String? {
        switch self {
        case .invalid(let errorMessage, _):
            return errorMessage
        default:
            return nil
        }
    }
    
    var actionButtonTitle: String? {
        switch self {
        case .invalid(_, let actionButtonTitle):
            return actionButtonTitle
        default:
            return nil
        }
    }

}

struct TextFieldProperty {
    
    // top label
    var titleLabelTitle: String? = nil
    var titleLabelTextColorNormal: UIColor = .black
    var titleLabelTextColorActive: UIColor = .blue
    var titleLabelTextColorError: UIColor = .red
    var titleLabelFont: UIFont = .systemFont(ofSize: 10)
    
    // textfield
    var placeholderText: String = "Enter text here"
    var placeholderColor: UIColor = .black
    var placeholderFont: UIFont = .systemFont(ofSize: 12)
    
    // hint label
    var hintLabelTitle: String?
    var hintLabelColor: UIColor = .black
    var hintLabelFont: UIFont = .systemFont(ofSize: 10)
    
    // error label
    var errorLabelColor: UIColor = .red
    var errorLabelFont: UIFont = .systemFont(ofSize: 10)
    
    // textfield
    var textfieldTextColorNormal: UIColor = .black
    var textfieldTextColorActive: UIColor = .blue
    var textfieldTextColorError: UIColor = .red
    var textfieldTextFont: UIFont = .systemFont(ofSize: 12)
    
    // right status imageview
    var rightValidIcon: UIImage? = nil
    var rightInvalidIcon: UIImage? = nil
    
    // action button
    var actionButtonTitle: String?
    var actionButtonTitleColor: UIColor = .blue
    var actionButtonFont: UIFont = .systemFont(ofSize: 12)
    
    // left view
    var leftSubview: UIView = UILabel()
    
    // padding
    var commonPadding: CGFloat = 10.0
    
    var borderWidth: CGFloat = 1
    var cornerRadius: CGFloat = 10
    var borderColorNormal: UIColor = .clear
    var borderColorActive: UIColor = .blue
    var borderColorError: UIColor = .red
    
    var backgroundColor: UIColor = .clear
    var mainContentColor: UIColor = .white
}

protocol ValidationTextfieldProtocol: class {

    func actionButtonDidTap()
    func textDidChanged(_ text: String?)
    func validateText(_ text: String?) -> TextfieldValidation
}

//@IBDesignable
class ValidationTextfield: NibView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var textfield: CustomTextfield!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    weak var delegate: ValidationTextfieldProtocol?
    
    var property: TextFieldProperty!
    
    /// The value of the title appearing duration
    @objc dynamic open var titleFadeInDuration: TimeInterval = 0.2
    /// The value of the title disappearing duration
    @objc dynamic open var titleFadeOutDuration: TimeInterval = 0.3
    
    private var _errorMessage: String?
    private var _actionButtonTitle: String?
    
    func setProperty(_ property: TextFieldProperty) {
        self.property = property
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textfield.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    }
    
    func setup() {
        textfield.customDelegate = self
        textfield.delegate = self
        
        backgroundColor = property.backgroundColor
        titleLabel.backgroundColor = .clear
        textfield.backgroundColor = .clear
        errorLabel.backgroundColor = .clear
        hintLabel.backgroundColor = .clear
        
        topView.layer.masksToBounds = true
        topView.backgroundColor = property.mainContentColor
        topView.layer.borderWidth = property.borderWidth
        topView.layer.cornerRadius = property.cornerRadius
        topView.layer.borderColor = property.borderColorNormal.cgColor
        
        textfield.borderStyle = .none
        textfield.attributedPlaceholder = NSAttributedString(string: property.placeholderText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: property.placeholderColor, NSAttributedString.Key.font: property.placeholderFont])
        textfield.font = property.textfieldTextFont
        textfield.textColor = property.textfieldTextColorNormal
        
        titleLabel.text = property.titleLabelTitle
        titleLabel.isHidden = true
        titleLabel.font = property.titleLabelFont
        
        hintLabel.text = property.hintLabelTitle
        hintLabel.isHidden = true
        hintLabel.font = property.hintLabelFont
        
        errorLabel.isHidden = true
        errorLabel.font = property.errorLabelFont
        
        statusButton.isHidden = true
        statusButton.isUserInteractionEnabled = false
        statusButton.setImage(nil, for: .normal)
        
        actionButton.setTitleColor(property.actionButtonTitleColor, for: .normal)
        actionButton.titleLabel?.font = property.actionButtonFont
        actionButton.isHidden = true
        actionButton.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        
        
        bottomStackView.isHidden = true
        leftView.addSubview(property.leftSubview)
        property.leftSubview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            property.leftSubview.widthAnchor.constraint(equalTo: leftView.widthAnchor),
            property.leftSubview.heightAnchor.constraint(equalTo: leftView.heightAnchor),
            property.leftSubview.centerXAnchor.constraint(equalTo: leftView.centerXAnchor),
            property.leftSubview.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
            ])
    }
    
    private func updateControl(animated: Bool = false) {
        
        updateTitleLabel(animated: true)
        updateStatusButton()
        updateCorner()
        updateErrorLabel()
        updateHintLabel()
        updateActionButton()
        updateBottomView()
    }
    
    fileprivate func updateActionButton() {
        actionButton.isHidden = !hasActionButton
    }
    
    fileprivate func updateBottomView() {
        bottomStackView.isHidden = actionButton.isHidden && errorLabel.isHidden && hintLabel.isHidden
    }
    
    fileprivate func updateErrorLabel() {
        errorLabel.textColor = property.errorLabelColor
        errorLabel.text = _errorMessage
        
        if state == .error && hasErrorMessage {
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
    }
    
    fileprivate func updateHintLabel() {
        if errorLabel.isHidden == false {
            hintLabel.isHidden = true
            return
        }
        hintLabel.textColor = property.hintLabelColor
        hintLabel.text = property.hintLabelTitle
        hintLabel.isHidden = (property.hintLabelTitle == nil || property.hintLabelTitle?.isEmpty ?? true)
    }
    
    fileprivate func updateCorner(animated: Bool = false) {
        switch state {
        case .normal:
            topView.layer.borderColor = property.borderColorNormal.cgColor
        case .normalActive:
            topView.layer.borderColor = property.borderColorActive.cgColor
        case .valid:
            topView.layer.borderColor = property.borderColorActive.cgColor
        case .error:
            topView.layer.borderColor = property.borderColorError.cgColor
        }
    }
    
    fileprivate func updateTitleLabel(animated: Bool = false) {
        switch state {
        case .normal:
            titleLabel.textColor = property.titleLabelTextColorNormal
        case .normalActive:
            titleLabel.textColor = property.titleLabelTextColorActive
        case .valid:
            titleLabel.textColor = property.titleLabelTextColorActive
        case .error:
            titleLabel.textColor = property.titleLabelTextColorError
        }
        
        updateTitleVisibility(animated)
    }
    
    fileprivate func updateStatusButton() {
        switch state {
        case .normal, .normalActive:
            statusButton.isHidden = true
        case .valid, .error:
            statusButton.isHidden = false
        }
    }
    
    fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        if isTitleVisible {
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
    }
    
    open var isTitleVisible: Bool {
        if editingOrSelected {
            return true
        }
        if let titleText = textfield.text {
            return !titleText.isEmpty
        }
        return false
    }
    
    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return textfield.editingOrSelected
    }
    
    /// A Boolean value that determines whether the receiver has an error message.
    open var hasErrorMessage: Bool {
        return _errorMessage != nil && _errorMessage != ""
    }
    
    open var hasActionButton: Bool {
        guard let actionButtonTitle = _actionButtonTitle else { return false }
        return !actionButtonTitle.isEmpty
    }
    
    open var actionButtonTitle: String? {
        set {
            _actionButtonTitle = newValue
            actionButton.setTitle(_actionButtonTitle, for: .normal)
        }
        get {
            return _actionButtonTitle
        }
    }
    
    open var errorMessage: String? {
        set {
            _errorMessage = newValue
        }
        get {
            return _errorMessage
        }
    }
    
    open var isValidText: Bool = false {
        didSet {
            statusButton.setImage(isValidText ? property.rightValidIcon : property.rightInvalidIcon, for: .normal)
        }
    }
    
    open var state: ValidationTextFieldState {
        get {
            if textfield.text == nil || (textfield.text ?? "").isEmpty {
                if editingOrSelected {
                    return .normalActive
                } else {
                    return .normal
                }
            } else if isValidText {
                return .valid
            } else {
                return .error
            }
        }
    }
    
    fileprivate var _renderingInInterfaceBuilder: Bool = false
    
    // MARK: Responder handling
    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateControl(animated: true)
        return result
    }
    
    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateControl(animated: true)
        return result
    }
    
    @objc
    private func actionButtonDidTap() {
        delegate?.actionButtonDidTap()
    }
}


extension ValidationTextfield: CustomTextfieldProtocol, UITextFieldDelegate {
    
    func becomeFirstResponde() {
        updateControl(animated: true)
    }
    
    func resignFirstResponder() {
        updateControl(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
    
    @objc func textDidChanged() {
        if let delegate = delegate {
            let validation = delegate.validateText(textfield.text)
            switch validation {
            case .valid(let _actionButtonTitle):
                isValidText = true
                errorMessage = nil
                actionButtonTitle = _actionButtonTitle
            case .invalid(let _errorMessage, let _actionButtonTitle):
                isValidText = false
                errorMessage = _errorMessage
                actionButtonTitle = _actionButtonTitle
            }
        } else {
            // default: text is valid
            isValidText = true
            errorMessage = nil
            actionButtonTitle = nil
        }
        
        updateControl()
        
        delegate?.textDidChanged(textfield.text)
    }
}
