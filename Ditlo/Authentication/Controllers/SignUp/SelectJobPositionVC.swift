//
//  SelectJobPositionVC.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import DGCollectionViewLeftAlignFlowLayout

class SelectJobPositionVC: UIViewController {

    // views
    let selectJobPositionNavBar: AuthenticationNavBar = {
        let navbar = AuthenticationNavBar()
        navbar.needsBackButton = true
        navbar.needsRedRoundedButton = false
        navbar.isRedRoundedButtonEnabled = true
        navbar.needsGreyBorderButton = true
        navbar.greyBorderRoundedButtonText = "SKIP"
        return navbar
    }()
    
    let titleLabel = TitleLabel()
    var titleLabelWidthConstraint: NSLayoutConstraint?
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(presentInfoWindowModal), for: .touchUpInside)
        return button
    }()
    
    let infoButtonIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        let infoIcon = #imageLiteral(resourceName: "info-icon")
        iv.image = infoIcon
        return iv
    }()
    
    let searchJobsInput: CustomInputView = {
        let customInputView = CustomInputView()
        customInputView.inputType = .unspecified
        customInputView.titleConfig = TitleLabelConfiguration(titleText: "JOB KEYWORDS", titleFont: smallTitleFont)
        customInputView.hideBottomBorder = false
        customInputView.layer.zPosition = 1
        return customInputView
    }()
    

    let addJobContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    var addJobContainerTopConstraint: NSLayoutConstraint?

    let addJobButton = GreyBorderRoundedButton()
    var addJobButtonWidthConstraint: NSLayoutConstraint?

    let addJobLabel: UILabel = {
        let label = UILabel()
        label.text = "Can't find your job in the list?"
        label.textColor = ditloGrey
        label.font = defaultParagraphFont
        return label
    }()
    
    let addJobBottomBorder = PaddedBorderView()
    
    
    // results collection view
    let jobsListCollectionViewCellId = "jobsListCollectionViewCellId"
    lazy var jobsListCollectionView: UICollectionView = {
        let flowLayout = DGCollectionViewLeftAlignFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(JobSelectorCell.self, forCellWithReuseIdentifier: jobsListCollectionViewCellId)
        return cv
    }()
    
    let jobListLoadingView: UIView = {
        let view = UIView()
        return view
    }()
    
    let loadingContentView: LoadingContentView = {
        let view = LoadingContentView()
        view.loadingContentMessage = "LOADING JOBS LIST"
        return view
    }()

    
    let dismissKeyboardView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    
    // variables
    let jobPositionInfoWindowConfig = CustomInfoMessageConfig(title: "SELECT YOUR JOB POSITION", body: "Select your job by searching from the list below, or add a new one to our database. Doing this will help you be more reachable to people who are interested in what you do. If you prefer not to then you can just click skip")
    var isAddJobViewVisible: Bool = false
    var jobsList: [Job] = []
    var isSearchingJobs: Bool = false
    var searchedJobsList: [Job] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupChildDelegates()
        getJobListData()
        anchorChildViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func animateWithKeyboard(_ notification: NSNotification) {
        let moveUp = (notification.name == UIResponder.keyboardWillShowNotification)
        dismissKeyboardView.alpha = moveUp ? 1.0 : 0.0

    }
    
    @objc func presentInfoWindowModal() {
        SharedModalsService.instance.showInfoWindowModal(withInfoWindowConfig: jobPositionInfoWindowConfig, andAnimation: true)
    }
    
    @objc func dismissKeyboard() {
        searchJobsInput.dismissKeyboard()
    }
    
    func showAddJobView() {
        addJobContainerView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.addJobContainerTopConstraint?.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAddJobView() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.addJobContainerTopConstraint?.constant = -44.0
            self.view.layoutIfNeeded()
        }) { (isAnimationComplete) in
            if isAnimationComplete {
                self.addJobContainerView.isHidden = true
            }
        }
    }
    
    func setupChildDelegates() {
        selectJobPositionNavBar.delegate = self
        searchJobsInput.delegate = self
        jobsListCollectionView.delegate = self
        jobsListCollectionView.dataSource = self
        addJobButton.delegate = self
    }
    
    func getJobListData() {
        JobService.instance.getJobsList { (jobsListData) in
            self.jobsList = jobsListData
            self.jobListLoadingView.isHidden = true
            self.jobsListCollectionView.reloadData()
        }
    }
    
    func anchorChildViews() {
        // custom navbar
        self.view.addSubview(selectJobPositionNavBar)
        selectJobPositionNavBar.anchor(withTopAnchor: self.view.safeAreaLayoutGuide.topAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: self.view.safeAreaLayoutGuide.centerXAnchor, centreYAnchor: nil)
        
        // title label
        let titleConfig = TitleLabelConfiguration(titleText: "JOB POSITION", titleFont: defaultTitleFont)
        titleLabel.titleConfig = titleConfig
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(withTopAnchor: selectJobPositionNavBar.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 20.0, left: horizontalPadding, bottom: 0.0, right: 0.0))
        
        // calculate title label width and height
        let titleLabelSize: CGSize = CGSize(width: titleConfig.titleText.widthOfString(usingFont: titleConfig.titleFont) + 1.0, height: titleConfig.titleText.heightOfString(usingFont: titleConfig.titleFont))
        titleLabelWidthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: titleLabelSize.width)
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleLabelSize.height)
        self.view.addConstraints([titleLabelWidthConstraint!, titleLabelHeightConstraint!])
        
        // info button
        self.view.addSubview(infoButton)
        infoButton.anchor(withTopAnchor: titleLabel.topAnchor, leadingAnchor: titleLabel.trailingAnchor, bottomAnchor: titleLabel.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: 10.0, bottom: 0.0, right: -horizontalPadding))
        infoButton.addSubview(infoButtonIconImageView)
        infoButtonIconImageView.anchor(withTopAnchor: nil, leadingAnchor: infoButton.leadingAnchor, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: nil, centreYAnchor: infoButton.centerYAnchor, widthAnchor: 14.0, heightAnchor: 14.0)
        
        // search bar
        self.view.addSubview(searchJobsInput)
        searchJobsInput.anchor(withTopAnchor: titleLabel.bottomAnchor, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0))

       // add job stuff
        self.view.addSubview(addJobContainerView)
        addJobContainerView.anchor(withTopAnchor: nil, leadingAnchor: self.view.safeAreaLayoutGuide.leadingAnchor, bottomAnchor: nil, trailingAnchor: self.view.safeAreaLayoutGuide.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: 44.0, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        addJobContainerTopConstraint = NSLayoutConstraint(item: addJobContainerView, attribute: .top, relatedBy: .equal, toItem: searchJobsInput, attribute: .bottom, multiplier: 1.0, constant: -44.0)
        self.view.addConstraint(addJobContainerTopConstraint!)
        
        addJobContainerView.addSubview(addJobButton)
        addJobButton.isUserInteractionEnabled = false
        addJobButton.buttonText = "ADD IT"
        addJobButton.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: addJobContainerView.trailingAnchor, centreXAnchor: nil, centreYAnchor: addJobContainerView.centerYAnchor, widthAnchor: nil, heightAnchor: 26.0)
        let addJobButtonWidth = (addJobButton.buttonText?.widthOfString(usingFont: redButtonFont))! + 32.0
        addJobButtonWidthConstraint = NSLayoutConstraint(item: addJobButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: addJobButtonWidth)
        self.view.addConstraint(addJobButtonWidthConstraint!)

        addJobContainerView.addSubview(addJobLabel)
        addJobLabel.anchor(withTopAnchor: addJobContainerView.topAnchor, leadingAnchor: addJobContainerView.leadingAnchor, bottomAnchor: addJobContainerView.bottomAnchor, trailingAnchor: addJobButton.leadingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        
        // jobs list collection view
        self.view.addSubview(jobsListCollectionView)
        jobsListCollectionView.anchor(withTopAnchor: addJobContainerView.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil, widthAnchor: nil, heightAnchor: nil, padding: .init(top: 0.0, left: horizontalPadding, bottom: 0.0, right: -horizontalPadding))
        
        // loading stuff
        self.view.addSubview(jobListLoadingView)
        jobListLoadingView.anchor(withTopAnchor: searchJobsInput.bottomAnchor, leadingAnchor: self.view.leadingAnchor, bottomAnchor: self.view.bottomAnchor, trailingAnchor: self.view.trailingAnchor, centreXAnchor: nil, centreYAnchor: nil)
        jobListLoadingView.addSubview(loadingContentView)
        loadingContentView.anchor(withTopAnchor: nil, leadingAnchor: nil, bottomAnchor: nil, trailingAnchor: nil, centreXAnchor: jobListLoadingView.centerXAnchor, centreYAnchor: jobListLoadingView.centerYAnchor)

       // dismiss keyboard view
        self.view.addSubview(dismissKeyboardView)
        dismissKeyboardView.fillSuperview()
    }
    
    func updateSelectJobPositionNavBar(withJob job: Job) {
        selectJobPositionNavBar.redRoundedButtonText = job.isSelected ? "SELECT JOB" : ""
        selectJobPositionNavBar.needsRedRoundedButton = job.isSelected
        selectJobPositionNavBar.needsGreyBorderButton = !job.isSelected
    }
    
    func navigateToSelectFavouriteCategoriesVC() {
        let selectFavouriteCategoriesVC = SelectFavouriteCategoriesVC()
        self.navigationController?.pushViewController(selectFavouriteCategoriesVC, animated: true)
    }
}


// select job position nav bar delegate methods
extension SelectJobPositionVC: AuthentationNavBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func greyBorderRoundedButtonPressed(buttonType: GreyBorderRoundedButtonType?) {
        navigateToSelectFavouriteCategoriesVC()
    }
    
    func redRoundedButtonPressed() {
        self.view.isUserInteractionEnabled = false
        SharedModalsService.instance.showCustomOverlayModal(withMessage: "SAVING JOB POSITION")
        jobsList.forEach { (job) in
            if job.isSelected {
                UserService.instance.updateUserData(withName: "job", andValue: job.jobName) { (jobPositionWasStoredSuccessfully) in
                    SharedModalsService.instance.hideCustomOverlayModal()
                    self.view.isUserInteractionEnabled = true
                    if jobPositionWasStoredSuccessfully {
                        self.navigateToSelectFavouriteCategoriesVC()
                    } else {
                        let jobPositionErrorConfig = CustomErrorMessageConfig(title: "JOB POSITION ERROR", body: "Something went wrong when trying to save your selected job position. Please try again, or click the 'skip' button to return to it later")
                        SharedModalsService.instance.showErrorMessageModal(withErrorMessageConfig: jobPositionInfoWindowConfig)
                    }
                }
            }
        }
    }
}


extension SelectJobPositionVC: GreyBorderRoundedButtonDelegate {
    func greyBorderRoundedButtonTapped(buttonType: GreyBorderRoundedButtonType?) {
        print("Add job button pressed")
    }
}


// input delegate methods
extension SelectJobPositionVC: CustomInputViewDelegate {
    
    func inputValueDidChange(inputType: CustomInputType, inputValue: String) {
        if !inputValue.isEmpty && !inputValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchedJobsList = jobsList.filter({ (job) -> Bool in
                return job.jobName.lowercased().contains(find: inputValue.lowercased())
            })
            isSearchingJobs = true
            
            if searchedJobsList.count > 0 {
                hideAddJobView()
            } else {
                showAddJobView()
            }
        } else {
            isSearchingJobs = false
            hideAddJobView()
        }
        jobsListCollectionView.reloadData()
    }
    
    func inputClearButtonPressed(inputType: CustomInputType) {
        isSearchingJobs = false
        hideAddJobView()
        jobsListCollectionView.reloadData()
    }
}


// collection view delegate methods
extension SelectJobPositionVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchingJobs ? searchedJobsList.count : jobsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let jobSelectorCell = collectionView.dequeueReusableCell(withReuseIdentifier: jobsListCollectionViewCellId, for: indexPath) as? JobSelectorCell else { return UICollectionViewCell() }
        jobSelectorCell.job = isSearchingJobs ? searchedJobsList[indexPath.item] : jobsList[indexPath.item]
        return jobSelectorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? JobSelectorCell else { return }
        
        if let cellJob = cell.job {
            for i in 0..<searchedJobsList.count {
                if searchedJobsList[i].jobName == cellJob.jobName {
                    searchedJobsList[i].isSelected = !searchedJobsList[i].isSelected
                } else {
                    searchedJobsList[i].isSelected = false
                }
            }
            for i in 0..<jobsList.count {
                if jobsList[i].jobName == cellJob.jobName {
                    jobsList[i].isSelected = !jobsList[i].isSelected
                    self.updateSelectJobPositionNavBar(withJob: jobsList[i])
                } else {
                    jobsList[i].isSelected = false
                }
            }
            collectionView.reloadData()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isSearchingJobs && searchedJobsList.count > 0 {
            let searchResultCellWidth = searchedJobsList[indexPath.item].jobName.widthOfString(usingFont: defaultParagraphFont) + 38.0
            return CGSize(width: searchResultCellWidth, height: 40.0)
        } else if jobsList.count > 0 {
            let jobCellWidth = jobsList[indexPath.item].jobName.widthOfString(usingFont: defaultParagraphFont) + 38.0
            return CGSize(width: jobCellWidth, height: 40.0)
        } else {
            return CGSize(width: 0.0, height: 0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
