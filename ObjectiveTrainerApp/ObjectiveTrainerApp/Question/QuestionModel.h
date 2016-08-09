//
//  QuestionModel.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (nonatomic, strong) NSMutableArray *easyQuestions;
@property (nonatomic, strong) NSMutableArray *mediumQuestions;
@property (nonatomic, strong) NSMutableArray *hardQuestions;

- (NSMutableArray *)getQuestions:(QuizQuestionDifficulty)difficulty;

@end
