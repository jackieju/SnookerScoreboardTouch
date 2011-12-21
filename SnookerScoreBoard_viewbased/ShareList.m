//
//  ShareList.m
//  SnookerScoreBoard_viewbased
//
//  Created by juweihua on 12/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareList.h"
#import "SHK.h"
#import "SHKActionSheet.h"

@implementation ShareList
@synthesize text;
@synthesize shareMsg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [text release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onShareToFacebook:(id)sender {
    /*
    // Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
	SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!"];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    */
    NSString *t;
	
	if (text.selectedRange.length > 0)
		t = [shareMsg substringWithRange:text.selectedRange];
	
	else
		t = shareMsg;
    
	
	SHKItem *item = [SHKItem text:t];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    
	// Display the action sheet
	[actionSheet showFromToolbar:self.navigationController.toolbar];
}
@end
