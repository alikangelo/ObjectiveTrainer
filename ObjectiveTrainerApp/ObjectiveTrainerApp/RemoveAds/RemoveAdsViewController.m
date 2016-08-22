//
//  RemoveAdsViewController.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import "RemoveAdsViewController.h"
#import "SWRevealViewController.h"

@interface RemoveAdsViewController ()

{
    StoreKitHelper *_skHelper;
    SKProduct *_removeAdsProduct;
}

@end

@implementation RemoveAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Create store kit helper object
    // Retrieve item for sale
    _skHelper = [[StoreKitHelper alloc] init];
    _skHelper.delegate = self;
    [_skHelper retrieveProductIds];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Store Kit Helper Protocol Methods

- (void)productsRetrieved:(NSArray *)products
{
    if (products.count > 0)
    {
        _removeAdsProduct = products[0];
        
        // Set the info for the product
        self.productInfoLabel.text = _removeAdsProduct.localizedDescription;
        
        NSString *purchaseButtonTitle = [NSString stringWithFormat:@"Remove ads for %f", _removeAdsProduct.price.decimalValue];
        [self.productPurchaseButton setTitle:purchaseButtonTitle forState:UIControlStateNormal];
        
    }
}

- (IBAction)purchaseTapped:(id)sender
{
    // Initiate the payment process
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:_removeAdsProduct];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
