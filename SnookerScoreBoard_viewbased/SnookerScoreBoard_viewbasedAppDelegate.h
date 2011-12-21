//
//  SnookerScoreBoard_viewbasedAppDelegate.h
//  SnookerScoreBoard_viewbased
//
//  Created by juweihua on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnookerScoreBoard_viewbasedViewController;

@interface SnookerScoreBoard_viewbasedAppDelegate : NSObject <UIApplicationDelegate> {

    UINavigationController *_navigationController;
}
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SnookerScoreBoard_viewbasedViewController *viewController;

@end
