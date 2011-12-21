//
//  ShareList.h
//  SnookerScoreBoard_viewbased
//
//  Created by juweihua on 12/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShareList : UIViewController {
    NSString* shareMsg;
    UITextView *text;
}
@property (nonatomic, retain) IBOutlet UITextView *text;
@property (nonatomic, copy) NSString* shareMsg;
- (IBAction)onShareToFacebook:(id)sender;

@end
