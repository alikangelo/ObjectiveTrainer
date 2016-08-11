//
//  QuestionModel.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import "QuestionModel.h"
#import "Question.h"

@implementation QuestionModel

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialize staff in here
        self.easyQuestions = [[NSMutableArray alloc] init];
        self.mediumQuestions = [[NSMutableArray alloc] init];
        self.hardQuestions = [[NSMutableArray alloc] init];
        
        // Load question.json and parse out questions into arrays
        [self loadQuestions];
    }
    return self;
}


- (NSMutableArray *)getQuestions:(QuizQuestionDifficulty)difficulty
{
    if (difficulty == QuestionDiffivultyEasy)
    {
        return self.easyQuestions;
    }
    else if (difficulty == QuestionDiffivultyMedium)
    {
        return self.mediumQuestions;
    }
    else if (difficulty == QuestionDiffivultyHard)
    {
        return self.hardQuestions;
    }
    else
    {
        // Should not get into here
        return [[NSMutableArray alloc] init];
    }
}

- (void)loadQuestions
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"jason"];
    
    NSError *myerror;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&myerror];
    
    NSData *myJsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *myJsonDictionary = [NSJSONSerialization JSONObjectWithData:myJsonData options:NSJSONReadingAllowFragments error:nil];
    
    // Parse out easy questions
    NSArray *easyJsonArray = myJsonDictionary[@"easy"];
    self.easyQuestions = [self parseJsonArrayIntoQuestions:easyJsonArray forDifficulty:QuestionDifficultyEasy];

    // Parse out medium questions
    NSArray *mediumJsonArray = myJsonDictionary[@"medium"];
    self.mediumQuestions = [self parseJsonArrayIntoQuestions:mediumJsonArray forDifficulty:QuestionDifficultyMedium];
    
    // Parse out hard questions
    NSArray *hardJsonArray = myJsonDictionary[@"hard"];
    self.hardQuestions = [self parseJsonArrayIntoQuestions:hardJsonArray forDifficulty:QuestionDifficultyHard];
}

- (NSMutableArray*)parseJsonArrayIntoQuestions:(NSArray *)jsonArray forDifficulty:(QuizQuestionDifficulty)difficulty
{
    // Create temporary array to store newly created questions
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    // Loop through json objects in the passed array
    for (int i = 0; i < jsonArray.count; i++)
    {
        // Get the json obj at this index
        NSDictionary *jsonObject = jsonArray[i];
        
        // Create new question object
        Question *newQuestion = [[Question alloc] init];
        newQuestion.questionDifficulty = difficulty;
        
        if ([jsonObject[@"type"] isEqualToString:@"mc"])
        {
            // Parse out multiple choice type question
            newQuestion.questionType = QuestionTypeMC;
            newQuestion.questionText = jsonObject[@"question"];
            newQuestion.questionAnswer1 = jsonObject[@"answer0"];
            newQuestion.questionAnswer2 = jsonObject[@"answer1"];
            newQuestion.questionAnswer3 = jsonObject[@"answer2"];
            newQuestion.correctMCQuestionIndex = [jsonObject[@"correctanswer"] intValue];
        }
        else if ([jsonObject[@"type"] isEqualToString:@"image"])
        {
            // Parse out image out questions
            newQuestion.questionType = QuestionTypeImage;
            newQuestion.questionImageName = jsonObject[@"imagename"];
            newQuestion.offset_x = [jsonObject[@"x_coord"] intValue];
            newQuestion.offset_y = [jsonObject[@"y_coord"] intValue];
            newQuestion.answerImageName = jsonObject[@"answerimage"];
        }
        else if ([jsonObject[@"type"] isEqualToString:@"blank"])
        {
            // Parse out of fill in the blank questions
            newQuestion.questionType = QuestionTypeBlank;
            newQuestion.questionImageName = jsonObject[@"imagename"];
            newQuestion.answerImageName = jsonObject[@"answerimage"];
            newQuestion.correctAnswerForBlank = jsonObject[@"answer"];
        }
        
        // Add newly created question to temp array
        [tempArray addObject:newQuestion];
    }
    
    return tempArray;
}

@end
