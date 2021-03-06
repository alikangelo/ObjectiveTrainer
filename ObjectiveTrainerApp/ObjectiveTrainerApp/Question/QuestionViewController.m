//
//  QuestionViewController.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import "QuestionViewController.h"
#import "SWRevealViewController.h"


@interface QuestionViewController ()

{
    Question *_currentQuestion;
    UIView *_tappablePortionOfImageQuestion;
    UITapGestureRecognizer *_tapRecognizer;
    UITapGestureRecognizer *_scrollViewTapGestureRecognizer;
    
    ResultView *_resultView;
    UIView *_dimmedBackground;
    
    // Banner
    ADBannerView *_adView;
    BOOL _bannerIsVisible;
}

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add tap gesture recognizer to scrollview
    _scrollViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped)];
    [self.questionScrollView addGestureRecognizer:_scrollViewTapGestureRecognizer];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Hide everything
    [self hideAllQuestionElements];
    
    // Create quiz model
    self.model = [[QuestionModel alloc] init];
    
    // Check for difficulty level and retrieve question for desired level
    self.questions = [self.model getQuestions:self.questionDifficulty];
    
    // Display a random question
    [self randomizeQuestionForDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Call super implementation
    [super viewDidAppear:animated];
    
    // Create a result view
    _resultView = [[ResultView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _resultView.delegate = self;
    
    // Create dimmed bg
    _dimmedBackground = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 20)];
    _dimmedBackground.backgroundColor = [UIColor blackColor];
    _dimmedBackground.alpha = 0.4;
    
    // Check flag to see if we should show the ad
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *flag = [defaults objectForKey:@"removeads"];
/*
    if (![flag isEqualToString:@"bought"])
    {    // Create iAd banner and place at bottom
        _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
        _adView.delegate = self;
    }*/
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllQuestionElements
{
    // Hide header elements
    self.questionHeaderLabel.alpha = 0.0;

    CGRect answerHeaderLabelFrame = self.answerHeaderLabel.frame;
    answerHeaderLabelFrame.origin.y = 2000;
    self.answerHeaderLabel.frame = answerHeaderLabelFrame;
    
    
    // Hide answer background
    CGRect answerBackgroundFrame = self.answerBackgroundView.frame;
    answerBackgroundFrame.origin.y = 2000;
    self.answerBackgroundView.frame = answerBackgroundFrame;
    
    // Fade out the question text label
    self.questionText.alpha = 0.0;
    
    // Hide answer buttons and position off the screen
    CGRect buttonFrame = self.questionMCAnswer1.frame;
    buttonFrame.origin.y = 2000;
    self.questionMCAnswer1.frame = buttonFrame;
    
    CGRect buttonBulletFrame = self.questionMCAnswer1Bullet.frame;
    buttonBulletFrame.origin.y = 2000;
    self.questionMCAnswer1Bullet.frame = buttonBulletFrame;
    
    buttonFrame = self.questionMCAnswer2.frame;
    buttonFrame.origin.y = 2000;
    self.questionMCAnswer2.frame = buttonFrame;
    
    buttonBulletFrame = self.questionMCAnswer2Bullet.frame;
    buttonBulletFrame.origin.y = 2000;
    self.questionMCAnswer2Bullet.frame = buttonBulletFrame;

    buttonFrame = self.questionMCAnswer3.frame;
    buttonFrame.origin.y = 2000;
    self.questionMCAnswer3.frame = buttonFrame;

    buttonBulletFrame = self.questionMCAnswer3Bullet.frame;
    buttonBulletFrame.origin.y = 2000;
    self.questionMCAnswer3Bullet.frame = buttonBulletFrame;

    // Set fill in the blank elements off the screen
    buttonFrame = self.submitAnswerForBlankButton.frame;
    buttonFrame.origin.y = 2000;
    self.submitAnswerForBlankButton.frame = buttonFrame;
    
    buttonFrame = self.blankTextField.frame;
    buttonFrame.origin.y = 2000;
    self.blankTextField.frame = buttonFrame;
    
    self.submittedAnswerLabel.alpha = 0;
    
    // Set alpha for image view to 0, so that we can fade it in
    self.imageQuestionImageView.alpha = 0.0;
    
    // Remove the tappable uiview for image questions
    if (_tappablePortionOfImageQuestion.superview != nil)
    {
        [_tappablePortionOfImageQuestion removeFromSuperview];
    }
    
}
- (IBAction)menuButtonTapped:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

#pragma mark Question Methods

- (void)displayCurrentQuestion
{
    switch (_currentQuestion.questionType)
    {
        case QuestionTypeMC:
            [self displayMCQuestion];
            break;
        case QuestionTypeBlank:
            [self displayBlankQuestion];
            break;
        case QuestionTypeImage:
            [self displayImageQuestion]
            break;
            
        default:
            break;
    }
}

- (void)displayMCQuestion
{
    // Hide all elements
    [self hideAllQuestionElements];
    
    // Set question elements
    self.questionText.text = _currentQuestion.questionText;
    
    [self.questionMCAnswer1 setTitle:_currentQuestion.questionAnswer1 forState:UIControlStateNormal];
    [self.questionMCAnswer2 setTitle:_currentQuestion.questionAnswer2 forState:UIControlStateNormal];
    [self.questionMCAnswer3 setTitle:_currentQuestion.questionAnswer3 forState:UIControlStateNormal];
    
    // Set text for answer label and positioning
    self.answerHeaderLabel.text = @"Answer";
    CGRect answerLabelFrame = self.answerHeaderLabel.frame;
    answerLabelFrame.size.width = 280;
    self.answerHeaderLabel.frame = answerLabelFrame;
    [self.answerHeaderLabel sizeToFit];

    // Set question status label
    self.questionStatusLabel.text = @"Multiple Choice";
    
    // Adjust scrollview
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height);
    
    // Animate the labels and buttons back to their positions
    [UIView animateWithDuration:1 animations:^(void){
        
        // Fade question text in
        self.questionText.alpha = 1.0;
        
        // Position answer background
        CGRect answerBackgroundFrame = self.answerBackgroundView.frame;
        answerBackgroundFrame.origin.y = 218;
        self.answerBackgroundView.frame = answerBackgroundFrame;
        
    }];
    
    [UIView animateWithDuration:1
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Position answer 1 text
                         self.questionMCAnswer1.alpha = 1;
                         CGRect answerButton1Frame = self.questionMCAnswer1.frame;
                         answerButton1Frame.origin.y = 218;
                         self.questionMCAnswer1.frame = answerButton1Frame;
                         
                         self.questionMCAnswer1Bullet.alpha = 1;
                         CGRect answerButtonBullet1Frame = self.questionMCAnswer1Bullet.frame;
                         answerButtonBullet1Frame.origin.y = 218;
                         self.questionMCAnswer1Bullet.frame = answerButtonBullet1Frame;
                         
                         [self positionStatusBar:234]
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Position answer 2 text
                         self.questionMCAnswer2.alpha = 1;
                         CGRect answerButton2Frame = self.questionMCAnswer2.frame;
                         answerButton2Frame.origin.y = 318;
                         self.questionMCAnswer2.frame = answerButton2Frame;
                         
                         self.questionMCAnswer2Bullet.alpha = 1;
                         CGRect answerButtonBullet2Frame = self.questionMCAnswer2Bullet.frame;
                         answerButtonBullet2Frame.origin.y = 318;
                         self.questionMCAnswer2Bullet.frame = answerButtonBullet2Frame;
                         
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Position answer 3 text
                         self.questionMCAnswer3.alpha = 1;
                         CGRect answerButton3Frame = self.questionMCAnswer3.frame;
                         answerButton3Frame.origin.y = 418;
                         self.questionMCAnswer3.frame = answerButton3Frame;
                         
                         self.questionMCAnswer3Bullet.alpha = 1;
                         CGRect answerButtonBullet3Frame = self.questionMCAnswer3Bullet.frame;
                         answerButtonBullet3Frame.origin.y = 418;
                         self.questionMCAnswer3Bullet.frame = answerButtonBullet3Frame;

                     }
                     completion:nil];
    
    
}

- (void)displayImageQuestion
{
    // Hide all elements
    [self hideAllQuestionElements];
    
    // Set image question
    self.questionText.text = @"What is wrong with the code below? \n\n Tap the error.";
    self.questionText.alpha = 1.0;
    
    // Set Image
    UIImage *tempImage = [UIImage imageNamed:_currentQuestion.questionImageName];
    self.imageQuestionImageView.image = tempImage;
    
    // Get aspect ratio of image
    double aspect = tempImage.size.height/tempImage.size.width;
    
    // Resize imageview
    CGRect imageViewFrame = self.imageQuestionImageView.frame;
    imageViewFrame.size.width = self.view.frame.size.width
    imageViewFrame.size.height = tempImage.size.width * aspect;
    imageViewFrame.origin.y = 531 - imageViewFrame.size.height;
    self.imageQuestionImageView.frame = imageViewFrame;
    
    // Create tappable part
    int tappable_x = self.imageQuestionImageView.frame.origin.x + _currentQuestion.offset_x - 10;
    int tappable_y = self.imageQuestionImageView.frame.origin.y + _currentQuestion.offset_y - 10;
    
    _tappablePortionOfImageQuestion = [[UIView alloc] initWithFrame:CGRectMake(tappable_x, tappable_y, 20, 20)];
    _tappablePortionOfImageQuestion.backgroundColor = [UIColor clearColor];
    
    // Create and attach gesture recognizer
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageQuestionAnswered)];
    [_tappablePortionOfImageQuestion addGestureRecognizer:_tapRecognizer];
    
    
    // Add tappable part
    [self.questionScrollView addSubview:_tappablePortionOfImageQuestion];
    
    // Set instruction label
    self.answerHeaderLabel.text = @"Tap on the error on the image above.";
    CGRect answerLabelFrame = self.answerHeaderLabel.frame;
    answerLabelFrame.size.width = 280;
    self.answerHeaderLabel.frame = answerLabelFrame;
    [self.answerHeaderLabel sizeToFit];

    // Set question status label
    self.questionStatusLabel.text = @"Find The Error";
    
    // Animate the elements in
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Position the status bar
                         [self positionStatusBar:531];
                         
                         // Position answer background
                         CGRect answerBackgroundFrame = self.answerBackgroundView.frame;
                         answerBackgroundFrame.origin.y = 531;
                         self.answerBackgroundView.frame = answerBackgroundFrame;
                         
                     }
                     completion:nil];

    
    // Animate the elements in
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Reveal the instruction label and image
                         self.answerHeaderLabel.alpha = 1.0;
                         
                     }
                     completion:nil];

    // Reveal answer background and slide in
    [UIView animateWithDuration:1
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Slide up answer background with question
                         CGRect answerBackgroundFrame = self.answerBackgroundView.frame;
                         answerBackgroundFrame.origin.y = self.imageQuestionImageView.frame.origin.y + self.imageQuestionImageView.frame.size.height;
                         self.answerBackgroundView.frame = answerBackgroundFrame;
                         
                         // Slide up answer header/instruction label
                         CGRect answerLabelFrame = self.answerHeaderLabel.frame;
                         answerLabelFrame.origin.y = self.imageQuestionImageView.frame.origin.y + self.imageQuestionImageView.frame.size.height + 20;
                         self.answerHeaderLabel.frame = answerLabelFrame;
                         
                     }
                     completion:nil];

    
}

- (void)displayBlankQuestion
{
    // Hide all elements
    [self hideAllQuestionElements];
    
    // Set question image for fill in the blank question
    self.questionText.text = @"What is missing below? \n\n Type in the missing keyword.";
    self.questionText.alpha = 1.0;
    
    UIImage *tempImage = [UIImage imageNamed:_currentQuestion.questionImageName];
    self.imageQuestionImageView.image = tempImage;
    
    // Get aspect ratio of image
    double aspect = tempImage.size.height/tempImage.size.width;
    
    // Resize imageview
    CGRect imageViewFrame = self.imageQuestionImageView.frame;
    imageViewFrame.size.width = self.view.frame.size.width;
    imageViewFrame.size.height = tempImage.size.width * aspect;
    imageViewFrame.origin.y = 350 - imageViewFrame.size.height;
    self.imageQuestionImageView.frame = imageViewFrame;
    
    // Set instruction label text and Y-offset
    self.answerHeaderLabel.text = @"Fill in the keyword that is blurred in the image above (case-sensitive)";
    CGRect answerLabelFrame = self.answerHeaderLabel.frame;
    answerLabelFrame.size.width = 280;
    self.answerHeaderLabel.frame = answerLabelFrame;
    [self.answerHeaderLabel sizeToFit];
    
    // Set question status label
    self.questionStatusLabel.text = @"Fill In The Blank";
    
    // Adjust scrollview
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height);

    // Animate the elements in
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Position the answer background and status bar
                         [self positionStatusBar:350];
                         
                         CGRect answerBackgroundFrame = self.answerBackgroundView.frame;
                         answerBackgroundFrame.origin.y = 350;
                         self.answerBackgroundView.frame = answerBackgroundFrame;
                         
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Reveal the instruction label and image
                         self.imageQuestionImageView.alpha = 1.0;
                         
                     }
                     completion:nil];
    
    // Animate the elements in
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // Reveal and slide up the answer background
                         CGRect answerBackgroundFrame = self.answerBackgroundView.frame;
                         answerBackgroundFrame.origin.y = self.imageQuestionImageView.frame.origin.y + self.imageQuestionImageView.frame.size.height;
                         self.answerBackgroundView.frame = answerBackgroundFrame;
                         
                         // Reveal and slide up the answer header/instruction label
                         CGRect answerLabelFrame = self.answerHeaderLabel.frame;
                         answerLabelFrame.origin.y = self.imageQuestionImageView.frame.origin.y + self.imageQuestionImageView.frame.size.height + 20;
                         self.answerHeaderLabel.frame = answerLabelFrame;
                         
                         // Reveal and slide up the textbox
                         self.blankTextField.alpha = 1;
                         CGRect textboxFrame = self.blankTextField.frame;
                         textboxFrame.origin.y = 400;
                         self.blankTextField.frame = textboxFrame;
                         
                         // Reveal and slide up the submit button
                         self.submitAnswerForBlankButton.alpha = 1;
                         CGRect buttonFrame = self.submitAnswerForBlankButton.frame;
                         buttonFrame.origin.y = 400;
                         self.submitAnswerForBlankButton.frame = buttonFrame;
                         
                     }
                     completion:nil];


}

- (void)randomizeQuestionForDisplay
{
    // Randomize question
    int randomQuestionIndex = arc4random() % self.questions.count;
    _currentQuestion = self.questions[randomQuestionIndex];
    
    // Display the question
    [self displayCurrentQuestion];
}

- (void)positionStatusBar:(int)yorigin
{
    // Position status bar
    CGRect statusBarFrame = self.statusBarBackground.frame;
    statusBarFrame.origin.y = yorigin;
    self.statusBarBackground.frame = statusBarFrame;
    
    // Position question type label
    CGRect questionTypeFrame = self.statusBarQuestionTypeLabel.frame;
    questionTypeFrame.origin.y = yorigin;
    self.statusBarQuestionTypeLabel.frame = questionTypeFrame;
    
    // Position difficulty label
    CGRect questionDifficultyFrame = self.statusBarQuestionDifficultyLabel.frame;
    questionDifficultyFrame.origin.y = yorigin;
    self.statusBarQuestionDifficultyLabel.frame = questionDifficultyFrame;
    
    // Position score label
    CGRect scoreFrame = self.statusBarScoreLabel.frame;
    scoreFrame.origin.y = yorigin;
    self.statusBarScoreLabel.frame = scoreFrame;
}

#pragma mark Question Answer Handlers

- (IBAction)skipButtonClicked:(id)sender
{
    
    // When skip/next button is clicked, make sure title is Skip
    [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    
    // Animate the elements in
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void){
                         
                         [self hideAllQuestionElements];
                         
                     }
                     completion:^(BOOL finished) {
                        
                         // Randomize and display another question
                         [self randomizeQuestionForDisplay];

                     }];
}


- (IBAction)questionMCAnswer:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;
    BOOL isCorrect = NO;
    /*
    NSString *userAnswer = @"";
    switch (selectedButton.tag)
    {
    case 1:
        userAnswer = _currentQuestion.questionAnswer1;
        break;
    case 2:
        userAnswer = _currentQuestion.questionAnswer2;
        break;
    case 3:
        userAnswer = _currentQuestion.questionAnswer3;
        break;
    default:
        break;
    }*/
    
    if (selectedButton.tag == _currentQuestion.correctMCQuestionIndex)
    {
        // User got it right
        isCorrect = YES;
        
        
        // Save data

    }
    else
    {
        // User got it wrong
    }
    
    // Animate and fade the incorrect answers
    [UIView animateWithDuration:0.5
                     animations:^(void){
                     
                         if (_currentQuestion.correctMCQuestionIndex != 1)
                         {
                             self.questionMCAnswer1.alpha = 0;
                             self.questionMCAnswer1Bullet.alpha = 0;
                         }
                         
                         if (_currentQuestion.correctMCQuestionIndex != 2)
                         {
                             self.questionMCAnswer2.alpha = 0;
                             self.questionMCAnswer2Bullet.alpha = 0;
                         }
                         
                         if (_currentQuestion.correctMCQuestionIndex != 3)
                         {
                             self.questionMCAnswer3.alpha = 0;
                             self.questionMCAnswer3Bullet.alpha = 0;
                         }

                     }];

    // Display message for answer
    // [_resultView showResultForTextQuestion:isCorrect forUserAnswer:userAnswer forQuestion:_currentQuestion];
    
    self.questionText.text = isCorrect ? @"Correct!" : @"Incorrect!";
    
    // Save the question data
    [self saveQuestionsData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Change skip to next
    [self.skipButton setTitle:@"Next" forState:UIControlStateNormal];
}

- (void)imageQuestionAnswered
{
    // User got it right
    
    // Create point to show the spotlight
    int tappable_x = self.imageQuestionImageView.frame.origin.x + _currentQuestion.offset_x - 10;
    int tappable_y = self.imageQuestionImageView.frame.origin.y + _currentQuestion.offset_y - 10;
    CGPoint spotlight = CGPointMake(tappable_x, tappable_y);
    
    // Display message for correct answer
    [self.view addSubview:_resultView];
    [_resultView showImageResultAt:spotlight forResult:@"Correct!"];
    
    [self saveQuestionsData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:YES];
}

- (IBAction)blankSubmitted:(id)sender
{
    
    // Retract keyboard
    [self.blankTextField resignFirstResponder];

    // Get answer
    NSString *answer = self.blankTextField.text;

    // Hide the text box and go button
    self.blankTextField.alpha = 0;
    self.submitAnswerForBlankButton.alpha = 0;

    // Show submitted answer label
    self.submittedAnswerLabel.text = answer;
    self.submittedAnswerLabel.alpha = 1;
    
    BOOL isCorrect = NO;
    
    // Check if answer is right
    if ([answer isEqualToString:_currentQuestion.correctAnswerForBlank])
    {
        // User got it right
        isCorrect = YES;
    }
    else
    {
        // User got it wrong
    }
    
    // Clear the text field
    self.blankTextField.text = @"";
    
    // Display message for correct answer
    // [_resultView showResultForImageQuestion:YES forQuestion:_currentQuestion];
    
    self.questionText.text = isCorrect ? @"Correct!" : [NSString stringWithFormat:@"Incorrect: \n %@", _currentQuestion.correctAnswerForBlank];

    // Record question data
    [self saveQuestionsData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Change skip button to next button
    [self.skipButton setTitle:@"Next" forState:UIControlStateNormal];
}

- (void)saveQuestionsData:(QuizQuestionType)type withDifficulty:(QuizQuestionDifficulty)difficulty isCorrect:(BOOL)correct
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Save data based on type
    NSString *keyToSaveForType = @"";
    
    if (type == QuestionTypeBlank)
    {
        keyToSaveForType = @"Blank";
    }
    else if (type == QuestionTypeMC)
    {
        keyToSaveForType = @"MC";
    }
    else if (type == QuestionTypeImage)
    {
        keyToSaveForType = @"Image";
    }
    
    // Record that they answered an Image question
    int questionsAnsweredByType = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveForType]];
    questionsAnsweredByType++;
    [userDefaults setInteger:questionsAnsweredByType forKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveForType]];
    
    // Record that they answered an Image question correctly
    int questionsAnsweredByTypeCorrectly = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveForType]];
    questionsAnsweredByTypeCorrectly++;
    [userDefaults setInteger:questionsAnsweredByTypeCorrectly forKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveForType]];
    
    
    // Save data based on difficulty
    NSString *keyToSaveForDifficulty = @"";
    
    if (difficulty == QuestionDifficultyEasy)
    {
        keyToSaveForDifficulty = @"Easy";
    }
    else if (difficulty == QuestionDifficultyMedium)
    {
        keyToSaveForDifficulty = @"Medium";
    }
    else if (difficulty == QuestionDifficultyHard)
    {
        keyToSaveForDifficulty = @"Hard";
    }
    
    int questionAnsweredWithDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveForDifficulty]];
    questionAnsweredWithDifficulty++;
    [userDefaults setInteger:questionAnsweredWithDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSaveForDifficulty]];
    
    if (correct)
    {
        int questionAnsweredCorrectlyWithDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveForDifficulty]];
        questionAnsweredCorrectlyWithDifficulty++;
        [userDefaults setInteger:questionAnsweredCorrectlyWithDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSaveForDifficulty]];
    }
}



- (void)scrollViewTapped
{
    // Retract keyboard
    [self.blankTextField resignFirstResponder];
}

#pragma mark Result View Delegate Methods

- (void)resultViewDismissed
{
    // Animate it into view
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         _resultView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^(void){
                                              
                                              [self hideAllQuestionElements];
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              // Display the next question
                                              [self randomizeQuestionForDisplay];
                                              
                                          }];
                         [_resultView removeFromSuperview];
                     }];
    
}

- (void)resultViewHeightDetermined
{
    // Fade in dimmed background
    _dimmedBackground.alpha = 0;
    
    [self.view addSubview:_dimmedBackground];
    
    // Position result view below screen
    CGRect resultViewFrame = _resultView.frame;
    resultViewFrame.origin.y = 2000;
    _resultView.frame = resultViewFrame;
    
    [self.view addSubview:_resultView];
    
    // Animate it into view
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         _dimmedBackground.alpha = 0.4;
                         
                     }
                     completion:nil];

    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         CGRect resultViewFrame = _resultView.frame;
                         resultViewFrame.origin.y = (self.view.frame.size.height - _resultView.frame.size.height)/2;
                         _resultView.frame = resultViewFrame;
                         
                     }
                     completion:nil];

}

#pragma mark iAd Delegate Methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    // Banner was successfully retrieved. Show ad if ad is not visible
    if (_adView.superview == nil)
    {
        [self.view addSubview:_adView];
    }
    // Animate it into view
    [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    
    // Assumes the banner view is just off the bottom of the screen
    _adView.frame = CGRectOffset(_adView.frame, 0, -_adView.frame.size.height);
    
    // Adjust scrollview height so it doesn't get covered by the banner
    CGRect scrollViewFrame = self.questionScrollView.frame;
    scrollViewFrame.size.height = scrollViewFrame.size.height - _adView.frame.size.height;
    self.questionScrollView.frame = scrollViewFrame;
    
    [UIView commitAnimations];
    
    // Set flag
    _bannerIsVisible = YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // Banner failed to be retrieved. Remove ad if shown
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen
        _adView.frame = CGRectOffset(_adView.frame, 0, _adView.frame.size.height);
        
        // Adjust scrollview height ti be the full height of the view again
        CGRect scrollViewFrame = self.questionScrollView.frame;
        scrollViewFrame.size.height = self.view.frame.size.height
        self.questionScrollView.frame = scrollViewFrame;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
