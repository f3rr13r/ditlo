//
//  SelectProfilePictureVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit

class SelectProfilePictureVC: UIViewController {

    // views
    let selectProfilePictureNavBar: AuthenticationNavBar = {
        let navbar = AuthenticationNavBar()
        navbar.needsBackButton = false
        navbar.needsRedRoundedButton = false
        navbar.isRedRoundedButtonEnabled = false
        navbar.needsGreyBorderButton = true
        navbar.greyBorderRoundedButtonText = "SKIP"
        return navbar
    }()
    
    let titleLabel = TitleLabel()
    var titleLabelWidthConstraint: NSLayoutConstraint?
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    let pageInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a profile picture for your new ditlo account, or click next to leave it until later"
        label.font = defaultParagraphFont
        label.textColor = ditloGrey
        label.numberOfLines = 0
        return label
    }()
    
    let profileIconBodyImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let bigCircleImage = UIImage(named: "big-circle-icon")
        iv.image = bigCircleImage
        return iv
    }()
    
    let profileIconHeadImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        let bigCircleImage = UIImage(named: "big-circle-icon")
        iv.image = bigCircleImage
        iv.clipsToBounds = true
        return iv
    }()
    
    let takePhotoButton: RedRoundedButton = {
        let button = RedRoundedButton()
        button.buttonType = .takePhoto
        button.buttonText = "TAKE PHOTO"
        return button
    }()
    var takePhotoButtonWidthConstraint: NSLayoutConstraint?
    
    let goToGalleryButton: RedRoundedButton = {
        let button = RedRoundedButton()
        button.buttonType = .goToGallery
        button.buttonText = "GO TO GALLERY"
        return button
    }()
    var goToGalleryButtonWidthConstraint: NSLayoutConstraint?
    
    let tryAgainButton: GreyBorderRoundedButton = {
        let button = GreyBorderRoundedButton()
        button.buttonText = "CHOOSE AGAIN"
        button.isHidden = true
        return button
    }()
    var tryAgainButtonWidthConstraint: NSLayoutConstraint?
    
    let confirmImageSelectionButton: RedRoundedButton = {
        let button = RedRoundedButton()
        button.buttonType = .saveProfilePicture
        button.buttonText = "I LIKE IT. MOVE ON"
        button.isHidden = true
        return button
    }()
    var confirmImageSelectionButtonWidthConstraint: NSLayoutConstraint?
    
    // image picker controller
    lazy var imagePickerVC: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupChildDelegates()
        anchorChildViews()
    }
    
    func setupChildDelegates() {
        selectProfilePictureNavBar.delegate = self
        takePhotoButton.delegate = self
        goToGalleryButton.delegate = self
        tryAgainButton.delegate = self
        confirmImageSelectionButton.delegate = self
        imagePickerVC.delegate = self
    }
    
    func anchorChildViews() {
        // custom navbar
        self.view.addSubview(selectProfilePictureNavBar)
        selectProfilePictureNavBar.anchor(withTopAnchor: self.view.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "PROFILE PICTURE", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: selectProfilePictureNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        // calculate title label width and height
        let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
        titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
        self.view.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
        
        // instruction label
        self.view.addSubview(pageInstructionLabel)
        pageInstructionLabel.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 16.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        // profile background
        self.view.addSubview(profileIconBodyImageView)
        let profileBodyDiameter: CGFloat = self.view.frame.width * 1.25
        profileIconBodyImageView.anchor(withTopAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: view.centerXAnchor, centreYAnchor: nil, widthAnchor: profileBodyDiameter, heightAnchor: profileBodyDiameter, padding: .init(top: screenHeight * 0.6, left: 0.0, bottom: 0.0, right: 0.0))
        self.view.addSubview(profileIconHeadImageView)
        let profileHeadDiameter: CGFloat = self.view.frame.width * 0.5
        profileIconHeadImageView.layer.cornerRadius = profileHeadDiameter * 0.5
        profileIconHeadImageView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: profileIconBodyImageView.topAnchor, trailingAnchor: nil, centreXAnchor: view.centerXAnchor, centreYAnchor: nil, widthAnchor: profileHeadDiameter, heightAnchor: profileHeadDiameter, padding: .init(top: 0.0, left: 0.0, bottom: -24.0, right: 0.0))
        
        // buttons
        self.view.addSubview(takePhotoButton)
        takePhotoButton.anchor(withTopAnchor: nil, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: -20.0, right: 0.0))
        let takePhotoButtonWidth = (takePhotoButton.buttonText?.widthOfString(usingFont: redButtonFont))! + 32.0
        takePhotoButtonWidthConstraint = NSLayoutConstraint(item: takePhotoButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: takePhotoButtonWidth)
        self.view.addConstraint(takePhotoButtonWidthConstraint!)
        
        self.view.addSubview(goToGalleryButton)
        goToGalleryButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 0.0, left: 0.0, bottom: -20.0, right: -horizontalPadding))
        let goToGalleryButtonWidth = (goToGalleryButton.buttonText?.widthOfString(usingFont: redButtonFont))! + 32.0
        goToGalleryButtonWidthConstraint = NSLayoutConstraint(item: goToGalleryButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: goToGalleryButtonWidth)
        self.view.addConstraint(goToGalleryButtonWidthConstraint!)
        
        self.view.addSubview(tryAgainButton)
        tryAgainButton.anchor(withTopAnchor: nil, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: -20.0, right: 0.0))
        let tryAgainButtonWidth = (tryAgainButton.buttonText?.widthOfString(usingFont: redButtonFont))! + 32.0
        tryAgainButtonWidthConstraint = NSLayoutConstraint(item: tryAgainButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: tryAgainButtonWidth)
        self.view.addConstraint(tryAgainButtonWidthConstraint!)
        
        self.view.addSubview(confirmImageSelectionButton)
        confirmImageSelectionButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 26.0, padding: .init(top: 0.0, left: 0.0, bottom: -20.0, right: -horizontalPadding))
        let confirmImageSelectionButtonWidth = (confirmImageSelectionButton.buttonText?.widthOfString(usingFont: redButtonFont))! + 32.0
        confirmImageSelectionButtonWidthConstraint = NSLayoutConstraint(item: confirmImageSelectionButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: confirmImageSelectionButtonWidth)
        self.view.addConstraint(confirmImageSelectionButtonWidthConstraint!)
    }
    
    func updateProfileData(withImage image: UIImage) {
        self.view.isUserInteractionEnabled = false
        SharedModalsService.instance.showCustomOverlayModal(withMessage: "SAVING PROFILE PICTURE")
        UserService.instance.updateUserData(withName: "profileImageUrl", andValue: image) { (profilePictureWasStoredSuccessfully) in
            SharedModalsService.instance.hideCustomOverlayModal()
            self.view.isUserInteractionEnabled = true
            if profilePictureWasStoredSuccessfully {
                self.navigateToNextPage()
            } else {
                let profilePictureErrorConfig = CustomErrorMessageConfig(title: "PROFILE PICTURE ERROR", body: "Something went wrong when trying to save your selected profile picture. Please try again, or click the 'skip' button to return to it later")
                SharedModalsService.instance.showErrorMessageModal(withErrorMessageConfig: profilePictureErrorConfig)
            }
        }
    }
    
    func navigateToNextPage() {
        let selectJobPositionVC = SelectJobPositionVC()
        self.navigationController?.pushViewController(selectJobPositionVC, animated: true)
    }
}


// select profile picture nav bar delegate methods
extension SelectProfilePictureVC: AuthentationNavBarDelegate {
    
    func greyBorderRoundedButtonPressed(buttonType: GreyBorderRoundedButtonType?) {
        navigateToNextPage()
    }
}


// button delegate methods
extension SelectProfilePictureVC: RedRoundedButtonDelegate, GreyBorderRoundedButtonDelegate {
    
    func redRoundedButtonTapped(withButtonType buttonType: RedRoundedButtonType?) {
        if let buttonType = buttonType {
            switch buttonType {
            case .takePhoto:
                openImagePickerVC(withRequiredSourceType: .camera)
                break
            case .goToGallery:
                openImagePickerVC(withRequiredSourceType: .savedPhotosAlbum)
                break
            case .saveProfilePicture:
                if let profileImage = profileIconHeadImageView.image {
                    updateProfileData(withImage: profileImage)
                }
                break
            default: return
            }
        }
    }
    
    func greyBorderRoundedButtonTapped(buttonType: GreyBorderRoundedButtonType?) {
        revertToDefaultPageState()
    }
    
    func openImagePickerVC(withRequiredSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerVC.sourceType = sourceType
            self.present(imagePickerVC, animated: true, completion: nil)
        }
    }
}

// image picker vc delegate methods
extension SelectProfilePictureVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            proceedToImageSelectedPageState(withImage: editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            proceedToImageSelectedPageState(withImage: originalImage)
        } else {
            let profilePictureErrorConfig = CustomErrorMessageConfig(title: "PROFILE PICTURE ERROR", body: "Something went wrong when trying to upload your selected profile picture. Please try again, or click the 'skip' button to return to it later")
            SharedModalsService.instance.showErrorMessageModal(withErrorMessageConfig: profilePictureErrorConfig)
        }
    }
    
    func proceedToImageSelectedPageState(withImage image: UIImage) {
        profileIconHeadImageView.image = image
        takePhotoButton.isHidden = true
        goToGalleryButton.isHidden = true
        tryAgainButton.isHidden = false
        confirmImageSelectionButton.isHidden = false
    }
    
    func revertToDefaultPageState() {
        profileIconHeadImageView.image = UIImage(named: "big-circle-icon")
        tryAgainButton.isHidden = true
        confirmImageSelectionButton.isHidden = true
        takePhotoButton.isHidden = false
        goToGalleryButton.isHidden = false
    }
}
