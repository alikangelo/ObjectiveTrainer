//
//  StatsViewController.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *easyQuestionsStats;
@property (weak, nonatomic) IBOutlet UILabel *mediumQuestionsStats;
@property (weak, nonatomic) IBOutlet UILabel *hardQuestionsStats;



@end
