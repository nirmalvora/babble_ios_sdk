//
//  BabbleViewController.swift
//  babbleios
//
//  Created by iMac on 27/01/23.
//
import StoreKit
import UIKit
typealias BabbleSurveyViewCompletion = (() -> Void)
class BabbleViewController: UIViewController {
    var questionListResponse: [QuestionListResponseElement] = []
    var selectedAnswers: [QuestionListResponseElement] = []
    var survey: SurveyResponseElement? = nil
    var surveyInstanceId: String = ""
    var apiController : APIProtocol = BabbleAPIController()
    @IBOutlet weak var mostContainerView: UIView!
    @IBOutlet weak var ratingView: BabbleDraggableView!
    @IBOutlet weak var containerView: BabbleRoundedConrnerView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imgDraggView: UIImageView!
    @IBOutlet weak var dragViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewPrimaryTitle1: UIView!
    @IBOutlet weak var viewSecondaryTitle: UIView!
    @IBOutlet weak var lblPrimaryTitle1: UILabel!
    @IBOutlet weak var lblSecondaryTitle: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblQuizResult: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var poweredByButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewQuizResult: UIView!
    @IBOutlet weak var quizResultTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var quizResultBottomConstraint: NSLayoutConstraint!
    var keyboardRect : CGRect!
    @IBOutlet weak var containerLeading: NSLayoutConstraint!
    @IBOutlet weak var containerTrailing: NSLayoutConstraint!
    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    @IBOutlet weak var containerTop: NSLayoutConstraint!
    var completionBlock: BabbleSurveyViewCompletion?
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    var currentScreenIndex = -1
    var totalQuizQuestion: Int? = nil
    var widgetPosition =  "bottom-center"
    private var isKeyboardVisible = false
    var shouldRemoveWatermark = false
    var shouldShowCloseButton = true
    var shouldShowDarkOverlay = true
    var shouldShowProgressBar = true
    private var isFirstQuestionLaunched = false
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    var centerConstraint  : NSLayoutConstraint!
    var stackViewCenterConstraint  : NSLayoutConstraint!
    
    private var isClosingAnimationRunning: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let width = self.view.bounds.width * 0.119
        self.dragViewWidthConstraint.constant = width
        self.imgDraggView.layer.cornerRadius = 2.5
        //
        self.containerView.alpha = 0.0
        self.ratingView.alpha = 0.0
        self.ratingView.layer.shadowColor = UIColor.black.cgColor
        self.ratingView.layer.shadowOpacity = 0.25
        self.ratingView.layer.shadowOffset = CGSize.zero
        self.ratingView.layer.shadowRadius = 8.0
        self.mostContainerView.backgroundColor = kBackgroundColor
        self.containerView.backgroundColor = kBackgroundColor
        self.bottomView.backgroundColor = kBackgroundColor
        self.stackView.arrangedSubviews.forEach({ $0.backgroundColor = kBackgroundColor })
        if((survey?.document?.fields?.isQuiz?.booleanValue ?? false) == true) {
            totalQuizQuestion = 0
            selectedAnswers = []
            questionListResponse.forEach {
                if (($0.document?.fields?.questionTypeID?.integerValue ?? 0) == 2) {
                    totalQuizQuestion = totalQuizQuestion! + 1
                }
            }
            if(questionListResponse.last?.document?.fields?.questionTypeID?.integerValue != 9){
                do {
                    let thankYouCard = try JSONDecoder().decode(QuestionListResponseElement.self, from: Data("""
                    {
                            "document": {
                                "fields": {
                                    "question_desc": {
                                        "stringValue": ""
                                    },
                                    "question_type_id": {
                                        "integerValue": "9"
                                    }
                                },
                            },
                        }
                    """.utf8))
                    questionListResponse.append(thankYouCard)
                }catch {
                    print(error)
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.progressBar.tintColor = kBrandColor
        self.progressBar.trackTintColor = kBackgroundColor
        if self.shouldShowDarkOverlay {
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            } completion: { _ in
                
            }
        }
        
        if self.currentScreenIndex == -1 {
            self.presentNextScreen(checkForNextQuestion: nil,answer: nil,questionElement: nil)
        }
        let radius: CGFloat = 5.0
        self.bottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
    }
    
    fileprivate func getNextQuestionIndex(_ previousAnswer : String?) -> Int? {
        var nextSurveyIndex : Int!
        if currentScreenIndex == -1 {
            nextSurveyIndex = currentScreenIndex + 1
            return nextSurveyIndex
        }
        return nextSurveyIndex
    }
    
    func runCloseAnimation(_ completion: @escaping ()-> Void) {
        self.isClosingAnimationRunning = true
        UIView.animate(withDuration: 0.2) {
            self.ratingView.frame.origin.y = self.ratingView.frame.origin.y + self.ratingView.frame.size.height
        }
        if !self.shouldShowDarkOverlay {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.001)
        }
        UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn) {
            self.view.backgroundColor = UIColor.clear
        } completion: { _ in
            completion()
        }
    }
    
    @IBAction func onCloseTapped(_ sender: UIButton) {
        guard let completion = self.completionBlock else { return }
        self.runCloseAnimation {
            completion()
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    private func setupUIAccordingToConfiguration() {
        let question=questionListResponse[currentScreenIndex];
        if let value = question.document?.fields?.questionText?.stringValue {
            self.viewPrimaryTitle1.isHidden = false
            self.lblPrimaryTitle1.text = value
            
        } else {
            self.viewPrimaryTitle1.isHidden = true
        }
        self.lblPrimaryTitle1.textColor = textColor
        
        if let value = question.document?.fields?.questionDesc?.stringValue {
            self.viewSecondaryTitle.isHidden = false
            self.lblSecondaryTitle.text = value
        } else {
            self.viewSecondaryTitle.isHidden = true
        }
        self.lblSecondaryTitle.textColor = textColor
        
        let indexToAddOn = 3
        if self.stackView.arrangedSubviews.count > indexToAddOn {
            let subView = self.stackView.arrangedSubviews[indexToAddOn]
            subView.removeFromSuperview()
        }
        
        switch (String(question.document?.fields?.questionTypeID?.integerValue ?? -1))  {
        case "1":
            let view = BabbleSingleAndMultiSelectView.loadFromNib()
            view.delegate = self
            view.currentType = .checkBox
            view.setupViewWithOptions(question.document?.fields?.answers?.arrayValue?.values ?? [], type: .checkBox, parentViewWidth: self.stackView.bounds.width, nil)
            view.submitButtonTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            view.isHidden = true
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        case "2":
            let view = BabbleSingleAndMultiSelectView.loadFromNib()
            view.delegate = self
            view.currentType = .radioButton
            view.setupViewWithOptions(question.document?.fields?.answers?.arrayValue?.values ?? [], type: .radioButton, parentViewWidth: self.stackView.bounds.width,question.document?.fields?.correctAnswer?.stringValue ?? "")
            view.submitButtonTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            view.isHidden = true
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        case "3":
            let view = BabbleTextView.loadFromNib()
            view.delegate = self
            view.placeHolderText = "Type here"
            view.minCharsAllowed = 1
            view.submitButtonTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            view.isHidden = true
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        case "4":
            let view = BabbleNumericView.loadFromNib()
            view.delegate = self
            view.minValue = 1
            view.maxValue = 10
            view.ratingMinText = question.document?.fields?.minValDescription?.stringValue ?? ""
            view.ratingMaxText = question.document?.fields?.maxValDescription?.stringValue ?? ""
            view.submitButtonTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            view.isHidden = true
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        case "5":
            let view = BabbleNumericView.loadFromNib()
            view.delegate = self
            view.minValue = 1
            view.maxValue = 5
            view.ratingMinText = question.document?.fields?.minValDescription?.stringValue ?? ""
            view.ratingMaxText = question.document?.fields?.maxValDescription?.stringValue ?? ""
            view.submitButtonTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            view.isHidden = true
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        case "6":
            let view = BabbleWelcomeView.loadFromNib()
            view.delegate = self
            view.isHidden = true
            view.continueTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        case "7":
            let view = BabbleStarsView.loadFromNib()
            view.delegate = self
            view.isHidden = true
            view.ratingMinText = question.document?.fields?.minValDescription?.stringValue ?? "Not likely at all"
            view.ratingMaxText = question.document?.fields?.maxValDescription?.stringValue ?? "Extremely likely"
            view.submitButtonTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        case "8":
            let view = BabbleNumericView.loadFromNib()
            view.isForEmoji = true
            view.emojiArray = ["☹️", "🙁", "😐", "🙂", "😊"]
            view.delegate = self
            view.ratingMinText = question.document?.fields?.minValDescription?.stringValue ?? "Not likely at all"
            view.ratingMaxText = question.document?.fields?.maxValDescription?.stringValue ?? "Extremely likely"
            view.submitButtonTitle = question.document?.fields?.ctaText?.stringValue ?? "Submit"
            view.isHidden = true
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
        case "9":
            self.stackView.alignment = .center
            if((survey?.document?.fields?.isQuiz?.booleanValue ?? false) == true) {
                self.quizResultTopConstraint.constant = 5
                self.quizResultBottomConstraint.constant = 5
                var correctAnswer = 0
                self.selectedAnswers.forEach {
                    if(
                        $0.document?.fields?.correctAnswer?.stringValue == $0.selectedOptions
                    ){
                        correctAnswer += 1
                    }
                }
                var resultText = ""
                if(totalQuizQuestion == 1){
                    if(correctAnswer == 1){
                        resultText = "Correct answer ✅"
                    }else{
                        resultText = "Incorrect answer ❌"
                    }
                }else {
                    resultText = "All Done 😀 \(correctAnswer) of \(totalQuizQuestion ?? 0) correct ✅"
                }
                self.viewQuizResult.isHidden = false
                self.lblQuizResult.text = resultText
                self.lblQuizResult.textColor = textColor
            }
            let delay = (survey?.document?.fields?.isQuiz?.booleanValue ?? false) == true ? 3 : 1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
                guard let completion = self.completionBlock else { return }
                self.runCloseAnimation {
                    completion()
                }
            }
            break
        default:
            let view = BabbleWelcomeView.loadFromNib()
            view.delegate = self
            view.continueTitle = question.document?.fields?.ctaText?.stringValue ?? ""
            self.stackView.insertArrangedSubview(view, at: indexToAddOn)
            break
        }
        
        
        
        //        for subview animation
        //        for subview in self.stackView.arrangedSubviews {
        //            subview.alpha = 0.0
        //            subview.backgroundColor = kBackgroundColor
        //        }
        
        UIView.animate(withDuration: 0.3) {
            if self.stackView.arrangedSubviews.count > 3 {
                self.stackView.arrangedSubviews[3].isHidden = false
            }
            
        } completion: { _ in
            self.stackView.alpha = 1.0
            
            if self.currentScreenIndex == 0 || !self.isFirstQuestionLaunched {
                self.isFirstQuestionLaunched = true
                
                let originalPosition = self.ratingView.frame.origin.y
                self.ratingView.frame.origin.y = self.view.frame.size.height
                self.ratingView.alpha = 1.0
                self.containerView.alpha = 1.0
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut) {
                    self.ratingView.frame.origin.y = originalPosition
                } completion: { _ in
                    
                    
                    //for subview animation
                    //                        var totalDelay = 0.0
                    //                        for subView in self.stackView.arrangedSubviews {
                    //                            UIView.animate(withDuration: 0.5, delay: totalDelay, options: UIView.AnimationOptions.allowUserInteraction) {
                    //                                subView.alpha = 1.0
                    //                            } completion: { _ in
                    //
                    //                            }
                    //                            totalDelay += 0.2
                    //                        }
                }
            } else {
                //                var totalDelay = 0.0
                //                for subView in self.stackView.arrangedSubviews {
                //                    UIView.animate(withDuration: 0.5, delay: totalDelay, options: UIView.AnimationOptions.allowUserInteraction) {
                //                        subView.alpha = 1.0
                //                    } completion: { _ in
                //
                //                    }
                //                    totalDelay += 0.2
                //                }
            }
        }
    }
    
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.isKeyboardVisible = true
        self.changePositionAsPerKeyboard()
    }
    
    func changePositionAsPerKeyboard() {
        if let _ = keyboardRect  {
            self.bottomConstraint.constant = keyboardRect.size.height //+ 20
            self.ratingView.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.isKeyboardVisible = false
        if let centerConstraint = self.centerConstraint {
            centerConstraint.constant = 0
        }
        if let stackCenterConstraint = self.stackViewCenterConstraint {
            stackCenterConstraint.constant = 0
        }
        self.bottomConstraint.constant = 0
        self.ratingView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func onBlankSpaceTapped(_ sender: Any) {
        if self.isKeyboardVisible == true {
            self.view.endEditing(true)
            return
        }
    }
    
    @objc func tapGestureAction(_ panGesture: UITapGestureRecognizer) {
        onBlankSpaceTapped(panGesture)
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: ratingView)
        if panGesture.state == .began {
            originalPosition = ratingView.center
            currentPositionTouched = panGesture.location(in: ratingView)
            
        } else if panGesture.state == .changed {
            if translation.y > 0 {
                ratingView.frame.origin = CGPoint(
                    x: ratingView.frame.origin.x,
                    y: (originalPosition?.y ?? 0) - (ratingView.frame.size.height / 2) + translation.y
                )
            }
            
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: ratingView)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                               , animations: {
                    self.ratingView.frame.origin = CGPoint(
                        x: self.ratingView.frame.origin.x,
                        y: self.view.frame.size.height
                    )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        guard let completion = self.completionBlock else { return }
                        completion()
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.ratingView.center = self.originalPosition!
                })
            }
        }
    }
}

extension BabbleViewController: BabbleSurveyResponseProtocol {
    func textSurveySubmit(_ text: String?) {
        self.presentNextScreen(checkForNextQuestion: text!, answer: text, questionElement: questionListResponse[currentScreenIndex])
    }
    
    func numericRatingSubmit(_ text: Int?) {
        self.presentNextScreen(checkForNextQuestion: String(text!),answer:  String(text!), questionElement: questionListResponse[currentScreenIndex])
    }
    
    func onWelcomeNextTapped() {
        self.presentNextScreen(checkForNextQuestion: nil,answer: nil, questionElement: nil)
    }
    func singleAndMultiSelectionSubmit(_ selectedOptions:[String]){
        if(!((questionListResponse[currentScreenIndex].document?.fields?.correctAnswer?.stringValue ?? "").isEmpty)){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.presentNextScreen(checkForNextQuestion: selectedOptions.isEmpty ? "" : selectedOptions[0],answer: selectedOptions.joined(separator: ","), questionElement: self.questionListResponse[self.currentScreenIndex])
            }
        }else{
            self.presentNextScreen(checkForNextQuestion: selectedOptions.isEmpty ? "" : selectedOptions[0],answer: selectedOptions.joined(separator: ","), questionElement: questionListResponse[currentScreenIndex])
        }
    }
    
    fileprivate func presentNextScreen(checkForNextQuestion: String?,answer:String?,questionElement: QuestionListResponseElement?) {
        var hasNextQuestion = true
        if(currentScreenIndex<(questionListResponse.count-1))
        {
            if(questionElement != nil){
                var question = questionElement
                question?.selectedOptions = answer ?? ""
                self.selectedAnswers.append(question!)
            }
            if (currentScreenIndex != -1 && checkForNextQuestion != nil && questionListResponse[currentScreenIndex].document?.fields?.nextQuestion != nil && (questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?[checkForNextQuestion!] != nil || questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?["any"] != nil)){
                hasNextQuestion = self.checkSkipLogic(questionElement: questionElement, checkForNextQuestion: checkForNextQuestion)
                if(!hasNextQuestion){
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        guard let completion = self.completionBlock else { return }
                        self.runCloseAnimation {
                            completion()
                        }
                    }
                }
            } else {
                currentScreenIndex = currentScreenIndex+1
                self.setupUIAccordingToConfiguration()
                self.progressBar.setProgress(Float(CGFloat(self.currentScreenIndex + 1 )/CGFloat(questionListResponse.count)), animated: true)
            }
        } else {
            hasNextQuestion = self.checkSkipLogic(questionElement: questionElement, checkForNextQuestion: checkForNextQuestion,isLastQuestion: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                guard let completion = self.completionBlock else { return }
                self.runCloseAnimation {
                    completion()
                }
            }
        }
        if(questionElement != nil)
        {
            self.addResponse(answer: answer ?? "", questionElement: questionElement!, hasNextQuestion: hasNextQuestion)
        }
    }
    
    private func checkSkipLogic( questionElement: QuestionListResponseElement?,checkForNextQuestion: String?, isLastQuestion: Bool = false) -> Bool {
        if((questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?["any"]?.stringValue ?? "").lowercased() == "in_app_survey"||(questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?[checkForNextQuestion!]?.stringValue ?? "").lowercased() == "in_app_survey")
        {
            presentReviewRequest()
            return false
        }else if((questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?["any"]?.stringValue ?? "").lowercased() == "babble_whatsapp_referral"||(questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?[checkForNextQuestion!]?.stringValue ?? "").lowercased() == "babble_whatsapp_referral")
        {
            var indexOfSkipLogic = (questionListResponse[currentScreenIndex].document?.fields?.skipLogicData?.arrayValue?.values ?? []).firstIndex{
                $0.mapValue?.fields?.respVal?.stringValue == checkForNextQuestion
            }
            if(indexOfSkipLogic == nil){
                indexOfSkipLogic = (questionListResponse[currentScreenIndex].document?.fields?.skipLogicData?.arrayValue?.values ?? []).firstIndex{
                    $0.mapValue?.fields?.respVal?.stringValue == "Any"
                    || $0.mapValue?.fields?.respVal?.stringValue == "any"
                }
            }
            var referralText = ""
            if(indexOfSkipLogic != nil){
                referralText = (questionListResponse[currentScreenIndex].document?.fields?.skipLogicData?.arrayValue?.values ?? [])[indexOfSkipLogic!].mapValue?.fields?.referralText?.stringValue ?? ""
            }
            let urlString = "whatsapp://send?text=\(referralText)"
            let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: urlStringEncoded!)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string:  urlStringEncoded!)! as URL)
            }
            return false
        }else{
            if (isLastQuestion) {
                return false
            }else{
                if((questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?[checkForNextQuestion!]?.stringValue ?? "").lowercased() == "end" || (questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?["any"]?.stringValue ?? "").lowercased() == "end"){
                    return false
                }else{
                    let index = questionListResponse[currentScreenIndex...(questionListResponse.count-1)].firstIndex{
                        if((questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?[checkForNextQuestion!]?.stringValue ?? "") != ""){
                            return (($0.document?.name ?? "") as NSString).lastPathComponent == (questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?[checkForNextQuestion!]?.stringValue ?? "")
                        }else if(questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?["any"] != nil){
                            return  (($0.document?.name ?? "") as NSString).lastPathComponent == (questionListResponse[currentScreenIndex].document?.fields?.nextQuestion?.mapValue?.fields?["any"]?.stringValue ?? "")
                        }else{
                            return false
                        }
                    }
                    if(index != nil){
                        currentScreenIndex = index!
                    }else{
                        currentScreenIndex = currentScreenIndex+1
                    }
                    self.setupUIAccordingToConfiguration()
                    self.progressBar.setProgress(Float(CGFloat(self.currentScreenIndex + 1 )/CGFloat(questionListResponse.count)), animated: true)
                    return true
                }
            }
        }
    }
    
    private func presentReviewRequest() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    func addResponse(answer: String,questionElement: QuestionListResponseElement, hasNextQuestion: Bool){
        let tempQuestionList =
        questionListResponse.filter { $0.document?.fields?.questionTypeID?.integerValue != 6 &&  $0.document?.fields?.questionTypeID?.integerValue != 9 }
        let surveyId = questionElement.document?.fields?.surveyID?.stringValue ?? ""
        let nextQuestionTracker = ( questionListResponse[currentScreenIndex].document?.fields?.questionTypeID?.integerValue ?? -1) != 9  && hasNextQuestion
        let questionTypeId = questionElement.document?.fields?.questionTypeID?.integerValue ?? -1
        let sequenceNo = questionElement.document?.fields?.sequenceNo?.integerValue ?? -1
        let questionText = questionElement.document?.fields?.questionText?.stringValue ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.string(from: Date())
        let addRequest = AddResponseRequest(surveyId: surveyId, surveyInstanceId: surveyInstanceId, questionText: questionText, responseCreateAt: date, responseUpdateAt: date, response: answer, questionTypeId: Int(questionTypeId), sequenceNo: Int(sequenceNo), shouldMarkComplete: tempQuestionList.last?.document?.name == questionElement.document?.name, shouldMarkPartial: tempQuestionList.last?.document?.name != questionElement.document?.name,nextQuestionTracker: nextQuestionTracker)
        apiController.addResponse(addRequest, { isSuccess, error, data in
            if isSuccess == true, let data = data {
                if let string = String(data: data, encoding: .utf8) {
                    print(string)
                }
            } else {
                print("createSurveyInstance failed")
            }
        })
    }
}
