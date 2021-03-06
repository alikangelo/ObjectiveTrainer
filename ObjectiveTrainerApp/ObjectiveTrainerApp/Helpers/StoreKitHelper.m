//
//  StoreKitHelper.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 17.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import "StoreKitHelper.h"

@implementation StoreKitHelper

- (void)retrieveProductIds
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"product_ids"
                                         withExtension:@"plist"];
    NSArray *productIdentifiers = [NSArray arrayWithContentsOfURL:url];
    
    // Pass product identifiers to the validate method
    [self validateProductIdentifiers:productIdentifiers];
}

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestsDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // Products retrieved, notify delegate
    if (self.delegate)
    {
        [self.delegate productsRetrieved:response.products];
    }
}

# pragma mark Transaction Observer Delegate Methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            // Call the appropriate custom method
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            
            case SKPaymentTransactionStateRestored:
                //[self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction*)transaction
{
    // Display a message to the user that purchase was successfull
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Purchase successful" message:@"Thank you! Your purchase was successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    // Set flag in user defaults to not show ads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"bought" forKey:@"removeads"];
    [defaults synchronize];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction*)transaction
{
    // Display a message to the user that purchase was not successfull
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Purchase canceled" message:@"Your purchase was canceled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end
