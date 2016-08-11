//
//  AboutViewController.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"


@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedbackButtonClicked:(id)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Objective C Trainer Feedback"];
    [mailComposer setToRecipients:@[@"codewithchris@gmail.com"]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (IBAction)rateButtonClicked:(id)sender {
}

- (IBAction)moreTutorialsButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://codewithchris.com"]];
}


#pragma mark Mail Compose Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // Dismiss the compose controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
