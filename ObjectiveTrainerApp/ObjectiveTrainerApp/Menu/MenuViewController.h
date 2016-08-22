//
//  MenuViewController.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"
#import "MenuItem.h"
#import "RemoveAdsView.h"

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, RemoveAdsViewProtocol>

@property (strong, nonatomic) MenuModel *model;
@property (strong, nonatomic) NSArray *menuItems;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attemptedLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
