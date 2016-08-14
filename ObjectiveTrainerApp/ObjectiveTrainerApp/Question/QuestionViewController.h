//
//  QuestionViewController.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "Question.h"
#import "ResultView.h"

@interface QuestionViewController : UIViewController<ResultViewProtocol>

@property (strong, nonatomic) QuestionModel *model;
@property (strong, nonatomic) NSArray *questions;

@property (nonatomic) QuizQuestionDifficulty questionDifficulty;
@property (weak, nonatomic) IBOutlet UIScrollView *questionScrollView;

// Properties for MC Questions
@property (weak, nonatomic) IBOutlet UILabel *questionHeaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionText;

@property (weak, nonatomic) IBOutlet UIButton *questionMCAnswer1;
@property (weak, nonatomic) IBOutlet UIButton *questionMCAnswer2;
@property (weak, nonatomic) IBOutlet UIButton *questionMCAnswer3;
@property (weak, nonatomic) IBOutlet UIImageView *answerHeaderLabel;

// Properties for Blank Questions

@property (weak, nonatomic) IBOutlet UIButton *submitAnswerForBlankButton;
@property (weak, nonatomic) IBOutlet UITextField *blankTextField;

// Properties for Image Questions

@property (weak, nonatomic) IBOutlet UIImageView *imageQuestionImageView;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end
