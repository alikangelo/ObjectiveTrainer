//
//  StoreKitHelper.h
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 17.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol StoreKitHelperProtocol <NSObject>

- (void)productsRetrieved:(NSArray*)products;

@end

@interface StoreKitHelper : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, weak) id<StoreKitHelperProtocol> delegate;

- (void)retrieveProductIds;

@end
