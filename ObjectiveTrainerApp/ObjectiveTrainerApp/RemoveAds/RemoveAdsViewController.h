//
//  RemoveAdsViewController.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreKitHelper.h"

@interface RemoveAdsViewController : UIViewController<StoreKitHelperProtocol>
@property (weak, nonatomic) IBOutlet UILabel *productInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *productPurchaseButton;

@end
