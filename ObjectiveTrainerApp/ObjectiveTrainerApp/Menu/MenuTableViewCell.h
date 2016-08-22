//
//  MenuTableViewCell.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 19.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *progressImageView;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void)setMenuCellTitle:(NSString*)title;

@end
