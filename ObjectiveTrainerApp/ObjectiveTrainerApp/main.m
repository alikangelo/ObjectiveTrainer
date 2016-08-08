//
//  main.m
//  ObjectiveTrainerApp
//
//  Created by Alik Hamdamov on 08.08.16.
//  Copyright © 2016 AlisherKh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

enum ScreenType {
    ScreenTypeQuestion,
    ScreenTypeStats,
    ScreenTypeAbout,
    ScreenTypeRemoveAds
};


int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
