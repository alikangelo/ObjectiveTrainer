//
//  MenuViewController.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "MenuTableViewCell.h"
#import "FXBlurView.h"

@interface MenuViewController ()

{
    UIAlertView *_resetPromptAlert;
    FXBlurView *_blurView;
    RemoveAdsView *_removeAdsView;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set self as the data source and delegate for the table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Fetch the menu items
    self.menuItems = [[[MenuModel alloc] init] getMenuItems];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Reload table
    [self.tableView reloadData];
    
    // Set stats
    [self calculateStats];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Stats Methods

- (void)calculateStats
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    int easyQuestionsAnswered = (int)[userDefaults integerForKey:@"EasyQuestionsAnswered"];
    int easyQuestionsCorrect = (int)[userDefaults integerForKey:@"EasyQuestionsAnsweredCorrectly"];
    int mediumQuestionsAnswered = (int)[userDefaults integerForKey:@"MediumQuestionsAnswered"];
    int mediumQuestionsCorrect = (int)[userDefaults integerForKey:@"MediumQuestionsAnsweredCorrectly"];
    int hardQuestionsAnswered = (int)[userDefaults integerForKey:@"HardQuestionsAnswered"];
    int hardQuestionsCorrect = (int)[userDefaults integerForKey:@"HardQuestionsAnsweredCorrectly"];
    
    int totalCorrect = easyQuestionsCorrect + mediumQuestionsCorrect + hardQuestionsCorrect;
    int totalAttempted = easyQuestionsAnswered + mediumQuestionsAnswered + hardQuestionsAnswered;
    
    int totalScore = (totalAttempted == 0) ? 0 : ((float)easyQuestionsCorrect/(float)easyQuestionsAnswered) * 100;
    
    // Set labels
    self.attemptedLabel.text = [NSString stringWithFormat:@"Total attempted %i", totalAttempted];
    self.scoreLabel.text = [NSString stringWithFormat:@"%i", totalScore];
}

#pragma mark Table View Delegate Methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (float)tableView: (UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 72.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // Retrieve cell
    NSString *cellIdentifier = @"MenuItemCell";
    MenuTableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (menuCell == nil)
    {
        // Create new MenuTableViewCell
        [tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        menuCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    // Get menu item that it's asking for
    MenuItem *item = self.menuItems[indexPath.row];
    
    // Set into the cell
    [menuCell setMenuCellTitle:item.menuTitle];
    
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check which item was tapped
    MenuItem *item = self.menuItems[indexPath.row];
    
    switch (item.screenType) {
        case ScreenTypeQuestion:
            // Go to question screen
            [self performSegueWithIdentifier:@"GoToQuestionsSegue" sender:self];
            break;
            
        case ScreenTypeStats:
            // Go to stats screen
            [self performSegueWithIdentifier:@"GoToStatsSegue" sender:self];
            break;
            
        case ScreenTypeAbout:
            // Go to about screen
            [self performSegueWithIdentifier:@"GoToAboutSegue" sender:self];
            break;
            
        case ScreenTypeRemoveAds:
            // Go to remove ads screen
            [self performSegueWithIdentifier:@"GoToRemoveAdsSegue" sender:self];
            break;
            
        default:
            break;
    }
}

#pragma mark Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Set the front view controller to be the destination one
    [self.revealViewController setFrontViewController:segue.destinationViewController];
    
    // Slide the front view controller back into place
    [self. revealViewController revealToggleAnimated:YES];
}

#pragma mark Button Methods

- (IBAction)resetButtonTapped:(id)sender
{
    if (_resetPromptAlert == nil)
    {
        _resetPromptAlert = [[UIAlertView alloc] initWithTitle:@"Reset Confirmation" message:@"Are you sure you want to reset the stats?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [_resetPromptAlert show];
    }
}

- (IBAction)removeAdsButtonTapped:(id)sender
{
    // Create a new blur view if we haven't done so already
    if (_blurView == nil)
    {
        _blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    // Set blur view properties
    _blurView.blurRadius = 15.0;
    _blurView.tintColor = [UIColor clearColor];
    
    // Add blur view
    [self.revealViewController.view addSubview:_blurView];
    
    // Create a new remove ads view if we haven't done so already
    if (_removeAdsView == nil)
    {
        _removeAdsView = [[RemoveAdsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _removeAdsView.delegate = self;
    }
    
    // Add the remove ads view
    [self.revealViewController.view addSubview:_removeAdsView];
}

- (IBAction)visitWebsiteButtonTapped:(id)sender
{
    // Open up safari to the app page
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://codewithchris.com"]];
}

#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // Yes tapped. Reset stats
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setValue:0 forKey:@"EasyQuestionsAnswered"];
        [userDefaults setValue:0 forKey:@"EasyQuestionsAnsweredCorrectly"];
        [userDefaults setValue:0 forKey:@"MediumQuestionsAnswered"];
        [userDefaults setValue:0 forKey:@"MediumQuestionsAnsweredCorrectly"];
        [userDefaults setValue:0 forKey:@"HardQuestionsAnswered"];
        [userDefaults setValue:0 forKey:@"HardQuestionsAnsweredCorrectly"];
        
        [userDefaults synchronize];
        
        UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Stats Reset" message:@"Stats have been reset" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [confirmAlert show];
        
        // Reset table view
        [self.tableView reloadData];
        
        // Update Stats labels
        [self calculateStats];
    }
}

#pragma mark Remove Ads View Delegate Methods

- (void)dismissRemoveAdsView
{
    // Remove blur view
    [_blurView removeFromSuperview];
    
    // Remove the RemoveAdsView
    [_removeAdsView removeFromSuperview];
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
