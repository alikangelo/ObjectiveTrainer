//
//  RemoveAdsView.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 21.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreKitHelper.h"

@protocol removeAdsViewProtocol <NSObject>

- (void)dismissRemoveAdsView;

@end

@interface RemoveAdsView : UIView<StoreKitHelperProtocol>

@property (nonatomic, weak) id<RemoveAdsViewProtocol> delegate;

- (void)retrieveProducts;

@end
