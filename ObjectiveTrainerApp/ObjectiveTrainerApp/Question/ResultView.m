//
//  ResultView.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 11.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor darkGrayColor];
        
        // Initialization properties to new ui element objects
        self.resultLabelBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        [self addSubview:self.resultLabelBackgroundView];
        
        self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        self.resultLabel.textColor = [UIColor whiteColor];
        self.resultLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.resultLabel];
        
        self.userAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 120, 200, 100)];
        self.userAnswerLabel.numberOfLines = 0;
        self.userAnswerLabel.textAlignment = NSTextAlignmentCenter;
        self.userAnswerLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.userAnswerLabel];
        
        self.correctAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 240, 100)];
        self.correctAnswerLabel.numberOfLines = 0;
        self.correctAnswerLabel.textAlignment = NSTextAlignmentCenter;
        self.correctAnswerLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.correctAnswerLabel];
        
        self.correctAnswerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 200)];
        [self addSubview:self.correctAnswerImageView];
        
        self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.continueButton.frame = CGRectMake(0, 350, self.frame.size.width, 50);
        [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        [self.continueButton addTarget:self action:@selector(continueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.continueButton];
        
    }
    return self;
}

- (void)hideAllElements
{
    self.resultLabel.hidden = YES;
    self.userAnswerLabel.hidden = YES;
    self.correctAnswerLabel.hidden = YES;
    self.correctAnswerImageView.hidden = YES;
    self.continueButton.hidden = YES;
}

- (void)showResultForTextQuestion:(BOOL)wasCorrect forUserAnswer:(NSString*)useranswer forQuestion:(Question*)question
{
    // Hide elements
    [self hideAllElements];
    
    
    // Set and show label if user was correct or not
    self.resultLabel.text = wasCorrect ? @"Correct!" : @"Incorrect!";
    self.resultLabel.hidden = NO;
    
    // Set background for result label
    if (wasCorrect)
    {
        self.resultLabelBackgroundView.backgroundColor = [UIColor colorWithRed:29/255.0 green:133/255.0 blue:15/255.0 alpha:1.0];
    }
    else
    {
        self.resultLabelBackgroundView.backgroundColor = [UIColor redColor];
    }
    
    // Set and show the user answer
    self.userAnswerLabel.text = [NSString stringWithFormat:@"Your answer was: \n%@", useranswer];
    self.userAnswerLabel.hidden = NO;
    
    // Position the user answer
    CGRect userAnswerLableFrame = self.userAnswerLabel.frame;
    userAnswerLableFrame.size.width = self.frame.size.width - 40;
    userAnswerLableFrame.origin.y = 60;
    self.userAnswerLabel.frame = userAnswerLableFrame;
    //[self.userAnswerLabel sizeToFit];
    
    // Show continue button
    CGRect continueButtonFrame = self.continueButton.frame;
    continueButtonFrame.origin.y = self.userAnswerLabel.frame.origin.y + self.userAnswerLabel.frame.size.height + 10;
    self.continueButton.frame = continueButtonFrame;
    
    if (!wasCorrect)
    {
        // Set and show the correct answer
        NSString *correctAnswerString = @"";
        switch (question.correctMCQuestionIndex)
        {
            case 1:
                correctAnswerString = question.questionAnswer1;
                break;
            case 2:
                correctAnswerString = question.questionAnswer2;
                break;
            case 3:
                correctAnswerString = question.questionAnswer3;
                break;
            default:
                break;
        }

        self.correctAnswerLabel.text = [NSString stringWithFormat:@"Correct answer was: \n%@", correctAnswerString];
        
        // Porision the correct answer label
        CGRect correctAnswerLabelFrame = self.correctAnswerLabel.frame;
        correctAnswerLabelFrame.origin.y = self.correctAnswerLabel.frame.origin.y + self.correctAnswerLabel.frame.size.height + 20;
        correctAnswerLabelFrame.size.width = self.frame.size.width - 40;
        self.correctAnswerLabel.frame = correctAnswerLabelFrame;
        //[self.correctAnswerLabel sizeToFit];
        
        // Show correct answer label
        self.correctAnswerLabel.hidden = NO;
        
        // Show continue button
        CGRect continueButtonFrame = self.continueButton.frame;
        continueButtonFrame.origin.y = self.correctAnswerLabel.frame.origin.y + self.correctAnswerLabel.frame.size.height + 10;
        self.continueButton.frame = continueButtonFrame;
    }
    
    // Finally show continue button
    self.continueButton.hidden = NO;
    
    // Resize view
    CGRect resultViewFrame = self.frame;
    resultViewFrame.size.height = self.continueButton.frame.origin.y + self.continueButton.frame.size.height + 10;
    self.frame = resultViewFrame;
    
    // Tell delegate that the height is determined
    if (self.delegate)
    {
        [self.delegate resultViewHeightDetermined];
    }
    
}

- (void)showResultForImageQuestion:(BOOL)wasCorrect forQuestion:(Question*)question
{
    // Hide elements
    [self hideAllElements];

    
    // Set and show label if user was correct or not
    self.resultLabel.text = wasCorrect ? @"Correct!" : @"Incorrect!";
    self.resultLabel.hidden = NO;
    
    // Set background for result label
    if (wasCorrect)
    {
        self.resultLabelBackgroundView.backgroundColor = [UIColor colorWithRed:29/255.0 green:133/255.0 blue:15/255.0 alpha:1.0];
    }
    else
    {
        self.resultLabelBackgroundView.backgroundColor = [UIColor redColor];
    }


    // Set and show correct answer image
    UIImage *tempImage = [UIImage imageNamed:question.answerImageName];
    self.correctAnswerImageView.image = tempImage;
    
    // Get aspect ratio of image
    double aspect = tempImage.size.height/tempImage.size.width;
    
    
    // Resize imageview
    CGRect imageViewFrame = self.correctAnswerImageView.frame;
    imageViewFrame.size.width = self.frame.size.width;
    imageViewFrame.size.height = imageViewFrame.size.width * aspect;
    self.correctAnswerImageView.frame = imageViewFrame;
    
    self.correctAnswerImageView.hidden = NO;
    
    // Position button below the image view
    CGRect buttonFrame = self.continueButton.frame;
    buttonFrame.origin.y = self.correctAnswerImageView.frame.origin.y + self.correctAnswerImageView.frame.size.height + 30;
    self.continueButton.frame = buttonFrame;
    
    // Show button
    self.continueButton.hidden = NO;
    
    // Resize view
    CGRect resultViewFrame = self.frame;
    resultViewFrame.size.height = self.continueButton.frame.origin.y + self.continueButton.frame.size.height + 10;
    self.frame = resultViewFrame;
    
    // Tell delegate that the height is determined
    if (self.delegate)
    {
        [self.delegate resultViewHeightDetermined];
    }

    
}

- (void)continueButtonClicked
{
    // Notify delegate that result view can be dismissed
    [self.delegate resultViewDismissed];
}


@end
