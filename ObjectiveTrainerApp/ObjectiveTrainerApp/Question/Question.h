//
//  Question.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 09.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic) QuizQuestionType questionType;
@property (nonatomic) QuizQuestionDifficulty questionDifficulty;

@property (strong, nonatomic) NSString *questionText;

// Properties for MC
@property (strong, nonatomic) NSString *questionAnswer1;
@property (strong, nonatomic) NSString *questionAnswer2;
@property (strong, nonatomic) NSString *questionAnswer3;
@property (nonatomic) int correctMCQuestionIndex;

// Properties for fill in the blanks
@property (strong, nonatomic) NSString *correctAnswerForBlank;

// Properties for find within image
@property (nonatomic) int offset_x;
@property (nonatomic) int offset_y;
@property (nonatomic, strong) NSString *questionImageName;
@property (nonatomic, strong) NSString *answerImageName;



@end
