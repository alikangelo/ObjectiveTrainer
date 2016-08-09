//
//  main.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


typedef enum ScreenType {
    ScreenTypeQuestion,
    ScreenTypeStats,
    ScreenTypeAbout,
    ScreenTypeRemoveAds
} MenuItemScreenType;

typedef enum QuestionType {
    QuestionTypeMC,
    QuestionTypeBlank,
    QuestionTypeImage
} QuizQuestionType;


typedef enum QuestionDifficulty {
    QuestionDifficultyEasy,
    QuestionDifficultyMedium,
    QuestionDifficultyHard
} QuizQuestionDifficulty;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
