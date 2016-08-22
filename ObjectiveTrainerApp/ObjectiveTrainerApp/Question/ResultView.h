//
//  ResultView.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 11.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol ResultViewProtocol <NSObject>

- (void)resultViewDismissed;

@end

@interface ResultView : UIView

@property (nonatomic, weak) id<ResultViewProtocol> delegate;

// Label to display correct or incorrect
@property(nonatomic, strong) UILabel *resultLabel;

// Button to next
@property(nonatomic, strong) UIButton *nextButton;

- (void)showImageResultAt:(CGPoint)point forResult:(NSString*)result;

@end
