//
//  SnookerScoreBoard_viewbasedViewController.m
//  SnookerScoreBoard_viewbased
//
//  Created by juweihua on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SnookerScoreBoard_viewbasedViewController.h"
#include <time.h>
#import "ShareList.h"
#import "SHK.h"
#import "SHKActionSheet.h"

@implementation SnookerScoreBoard_viewbasedViewController

@synthesize List1;
@synthesize score1;
@synthesize score2;
@synthesize timer;
@synthesize btStart;
@synthesize List2;
@synthesize listData1,listData2, one_pot, btsInInputView;
@synthesize game_timer;
@synthesize Player1;
@synthesize Player2;
@synthesize ivList1Frm;
@synthesize ivList2Frm;
@synthesize ivBG;


- (void)dealloc
{
    [List1 release];
    [List2 release];
    [score1 release];
    [score2 release];
    [timer release];
    [btStart release];
    [Player1 release];
    [Player2 release];
    [ivList1Frm release];
    [ivList2Frm release];
    [ivBG release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    game_status = 0;
    currentRow = -1;
    [super viewDidLoad];
   /* UIImageView *backView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];  
    [backView setImage:[UIImage imageNamed:@"back.jpg"]];  
    [backView setUserInteractionEnabled:YES]; 
    self.view = backView;
     [backView release];  */
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self InitTableView];
    input_view = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 150, 300, 50)];
   // input_view.alpha = 0; // transparent
    [self.view addSubview:input_view];
    //input_view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    input_view.hidden = YES;
    input_view.scrollEnabled = YES;
    [self InitKeyboardView]; 
   
    self.btsInInputView = [NSMutableArray arrayWithCapacity:30];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  
    NSString *value = [ud objectForKey:@"player1"]; 
    if (value)
    Player1.text = value;
    
   
    value = [ud stringForKey:@"player2"];  
    if (value)
    Player2.text = value;

    
//    List1.frame = CGRectMake(41, 131, 97, 246);
//    List2.frame = CGRectMake(177, 131, 97, 246);
//    [self adjustHeight:List1];
//    [self adjustHeight:List2];
    [self adjustHeight:ivList1Frm];
    [self adjustHeight:ivList2Frm];
    [self adjustPosition:btStart];
        [self adjustHeight:ivBG];
    
    CGRect r1 = ivList1Frm.frame;
    CGRect r11= List1.frame;
    r11.size.height = r1.size.height-25;
    List1.frame = r11;
    
    
    CGRect r2 = ivList2Frm.frame;
    CGRect r22= List2.frame;
    r22.size.height = r2.size.height-25;
    List2.frame = r22;
    
}
- (void) adjustPosition:(UIView*)v{
    CGRect r = v.frame;
    if ([UIScreen mainScreen].bounds.size.height > 480){
        CGRect rect = [UIScreen mainScreen].bounds;
        r.origin.y = r.origin.y*[UIScreen mainScreen].bounds.size.height/480.0f;
        v.frame =r;
    }
}
- (void) adjustHeight:(UIView*)v{
    CGRect r = v.frame;
    if ([UIScreen mainScreen].bounds.size.height > 480){
        CGRect rect = [UIScreen mainScreen].bounds;
        r.size.height = r.size.height*[UIScreen mainScreen].bounds.size.height/480.0f;
        v.frame =r;
    }
}
- (void) InitTableView{

    
    
    self.listData1 = [NSMutableArray arrayWithCapacity:20];
    self.listData2 = [NSMutableArray arrayWithCapacity:20];
  
    
    // configure table view
    [List1 setDataSource:self];
    [List1 setDelegate:self];
    List1.scrollEnabled = YES;
    List1.tag = 100;
//    //为视图增加边框      
//    List1.clipsToBounds=YES;      
//    List1.layer  cornerRadius=20.0;      
//    List1.layer.borderWidth=10.0;      
//    List1.layer.borderColor=[[UIColor blueColor] CGColor];      
//    
//    //为视图添加圆角
//    
//    List1.layer.cornerRadius = 6;
//    List1.layer.masksToBounds = YES;
    

    [self.view addSubview:List1];   
    
    [List2 setDataSource:self];
    [List2 setDelegate:self];
    List2.scrollEnabled = YES;
    List2.tag = 200;
    [self.view addSubview:List2];  
}

- (void)InitKeyboardView{
  //  keyboard_view = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 100)];
     keyboard_view = [[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 100)];
    [self.view addSubview:keyboard_view];
    keyboard_view.hidden = YES;
    keyboard_view.backgroundColor = [UIColor colorWithRed:125/255.0 green:133/255.0 blue:145/255.0 alpha:1.0];
    
    int width = 41.0;
    int height = 41.0;
    int padding = 5;
    int grid_height = height+padding;
    int grid_width = width+padding;
    // add buttons
    // red boll
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*0+2, grid_height*0+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"redboll.png"] forState:UIControlStateNormal];
    UIFont *font = [UIFont systemFontOfSize:30.0];
//    btn.titleLabel.cornerRadius = 8.0f;
//    btn.titleLabel.masksToBounds = NO;
//    btn.titleLabel.borderWidth = 1.0f;
    btn.titleLabel.shadowOffset =  CGSizeMake(3, 5);  
//    btn.titleLabel.shadowOpacity = 0.8;  
    btn.titleLabel.shadowColor =  [UIColor blackColor];
    btn.titleLabel.font = font;
   // [btn setTitle:[NSString stringWithFormat:@"%@", @"red"] forState:UIControlStateNormal];
    [btn setTag:1];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    //[btn release];
    
    // yellow
     btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*1+2, grid_height*0+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"yellowboll.png"] forState:UIControlStateNormal];
//    UIFont *font = [UIFont systemFontOfSize:30.0];
//    btn.font = font;
   // [btn setTitle:[NSString stringWithFormat:@"%@", @"yellow"] forState:UIControlStateNormal];
    [btn setTag:2];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
    // green
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*2+2, grid_height*0+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"greenboll.png"] forState:UIControlStateNormal];
    //    UIFont *font = [UIFont systemFontOfSize:30.0];
    //    btn.font = font;
   // [btn setTitle:[NSString stringWithFormat:@"%@", @"green"] forState:UIControlStateNormal];
    [btn setTag:3];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
    // brown
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*3+2, grid_height*0+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"brownboll.png"] forState:UIControlStateNormal];
    //    UIFont *font = [UIFont systemFontOfSize:30.0];
    //    btn.font = font;
  //  [btn setTitle:[NSString stringWithFormat:@"%@", @"brown"] forState:UIControlStateNormal];
    [btn setTag:4];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
    // blue
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*0+2, grid_height*1+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"blueboll.png"] forState:UIControlStateNormal];
    //    UIFont *font = [UIFont systemFontOfSize:30.0];
    //    btn.font = font;
  //  [btn setTitle:[NSString stringWithFormat:@"%@", @"blue"] forState:UIControlStateNormal];
    [btn setTag:5];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
    // pink
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*1+2, grid_height*1+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"pinkboll.png"] forState:UIControlStateNormal];
    //    UIFont *font = [UIFont systemFontOfSize:30.0];
    //    btn.font = font;
 //   [btn setTitle:[NSString stringWithFormat:@"%@", @"pink"] forState:UIControlStateNormal];
    [btn setTag:6];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
    // black
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*2+2, grid_height*1+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"blackboll.png"] forState:UIControlStateNormal];
    //    UIFont *font = [UIFont systemFontOfSize:30.0];
    //    btn.font = font;
 //   [btn setTitle:[NSString stringWithFormat:@"%@", @"black"] forState:UIControlStateNormal];
    [btn setTag:7];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
    // backspace
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((width+padding)*3+2, grid_height*1+8, width, height)];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //    UIFont *font = [UIFont systemFontOfSize:30.0];
    //    btn.font = font;
 //   [btn setTitle:[NSString stringWithFormat:@"%@", @"back"] forState:UIControlStateNormal];
    [btn setTag:-1];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
    // save
    btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [btn setFrame:CGRectMake(230, grid_height*0+8, 80, 60)];
   // [btn setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    //    UIFont *font = [UIFont systemFontOfSize:30.0];
    //    btn.font = font;
    [btn setTitle:[NSString stringWithFormat:@"%@", @"Close"] forState:UIControlStateNormal];
    [btn setTag:-2];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];

    btSave = btn;
}

- (void)DisplayKeyboardView{
    
}

- (void)viewDidUnload
{
    [self setList1:nil];
    [self setList2:nil];
    [self setScore1:nil];
    [self setScore2:nil];
    [self setTimer:nil];
    [self setBtStart:nil];
    [self setPlayer1:nil];
    [self setPlayer2:nil];
    [self setIvList1Frm:nil];
    [self setIvList2Frm:nil];
    [self setIvBG:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
  
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"KEY");
    
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"KEY hide");
}

- (void) cleanInputView{
    for (int i=0; i<[self.btsInInputView count]; i++){
        UIButton *bt =  [self.btsInInputView objectAtIndex:i];
        [bt removeFromSuperview];
        //[bt dealloc];
    }
    if ([self.btsInInputView count] > 0)
        [self.btsInInputView removeAllObjects];
    input_view.frame=CGRectMake(10, 150, 300, 50);
    [input_view setContentSize:CGSizeMake(300,50)];
    //    if ([self.one_pot count]>0)
//        [self.one_pot removeAllObjects];
}

- (IBAction)onRestart:(id)sender {
//    [SHK logoutOfAll];
    if (game_status == 0 || game_status == 2){ // start game
        input_view.hidden = YES;
        [self.btStart setTitle:@"Stop" forState:UIControlStateNormal];
        
        // clear timer
        [self.timer setText:[NSString stringWithFormat:@"%02d:%02d:%02d", 0, 0, 0 ]];

        // clear scores
        if ([self.listData1 count] >0)
            [self.listData1 removeAllObjects];
        if ([self.listData2 count]>0)
            [self.listData2 removeAllObjects];
        [self.List1 reloadData];
        [self.List2 reloadData];
        [self.score1 setText:@"0"];
        [self.score2 setText:@"0"];
        
        // start timer
        game_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)target:self selector:@selector(onTimer) userInfo:nil repeats:YES];	
        //  [t release];
       
        time(&t_start);
        game_status = 1;
    }else if (game_status == 1){  // stop game
        NSLog(@"stop");
        [self.btStart setTitle:@"Start" forState:UIControlStateNormal];
        game_status = 0;
        
        [game_timer invalidate];
    //    [game_timer release];

            
        ShareList* sl = [ShareList alloc];
        [sl initWithNibName:@"ShareView" bundle:nil];
        
        [self.navigationController pushViewController:sl animated:YES];
        
        NSString* shareMsg;
        int s1 = [self.score1.text integerValue];
        int s2 = [self.score2.text integerValue];
        NSString* winner = Player1.text;
        NSString* loser = Player2.text;
        int hb_player1 = 0;
        int hb_player2 = 0;
        int sum = 0;
        for (int i = 0; i< [listData1 count]; i++){
            sum = 0;
            NSMutableArray* pot = [listData1 objectAtIndex:i];
            for (int j = 0; j<[pot count]; j++){
                sum += [[pot objectAtIndex:j] integerValue];
            }
            if (sum > hb_player1)
                hb_player1 = sum;
        }
        for (int i = 0; i< [listData2 count]; i++){
            sum = 0;
            NSMutableArray* pot = [listData2 objectAtIndex:i];
            for (int j = 0; j<[pot count]; j++){
                sum += [[pot objectAtIndex:j] integerValue];
            }
            if (sum > hb_player2)
                hb_player2 = sum;
        }

        if (s1 == s2){
            [sl.text setText:[ [NSString alloc] initWithFormat:@"Draw !\nGame last %@ \nFinal Score: %d to %d\nHighest break %d-%d ", [self.timer text], s1, s2, hb_player1, hb_player2] ];
            sl.shareMsg =[[NSString alloc] initWithFormat:@"%@ tie %@ in a just finished snooker game!\nGame last %@ \nFinal Score: %d to %d\nHighest break %d-%d ", Player1.text, Player2.text, [self.timer text], s1, s2, hb_player1, hb_player2];
        }else{
            if (s1 < s2){
                winner = Player2.text;
                loser = Player1.text;
            }
                       
            if (s1 < s2){
                [sl.text setText:[[NSString alloc] initWithFormat:@"%@ win ! \nFinal Score %d-%d \nGame last %@ \nHighest break %d-%d", winner, s1, s2, [self.timer text], hb_player1, hb_player2]];
            
                sl.shareMsg =[[NSString alloc] initWithFormat:@"%@ beat %@ %d-%d in a just finished Snooker Game!\nGame last %@ \nHighest break %d-%d", winner, loser, s2, s1, [self.timer text], hb_player2, hb_player1];
            }
            else{
                [sl.text setText:[[NSString alloc] initWithFormat:@"%@ win ! \nFinal Score %d-%d \nGame last %@ \nHighest break %d-%d", winner, s1, s2, [self.timer text], hb_player1, hb_player2]];
                sl.shareMsg = [[NSString alloc] initWithFormat:@"%@ beat %@ %d-%d in a just finished Snooker Game!\nGame last %@ \nHighest break %d-%d", winner, loser, s1, s2, [self.timer text], hb_player1, hb_player2];
            }
        }
        
      
        [sl release];
                 
           }
    
    

    
 
}

- (IBAction)onShare:(id)sender {
    // Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
	SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!"];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
	// Display the action sheet
	[actionSheet showFromToolbar:self.navigationController.toolbar];

}

- (IBAction)onChangePlay1Name:(id)sender {
    NSString *string = [self.Player1 text]; 
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  
    [ud setObject:string forKey:@"player1"];  

}
- (void) onTimer
{
    time_t t;
    time(&t);
    long tt = t - t_start;
    int h = tt/3600;
    int m = (tt - h*3600)/60;
    int s = (tt - h*3600 - m*60);
    [self.timer setText:[NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s ]];
}
- (IBAction)AddScore1:(id)sender {
    if (game_status != 1){
        UIAlertView  *alert = [[ UIAlertView   alloc ]  initWithTitle :@"Game not started."
                                                              message :@""
                                                             delegate : nil   cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
        [alert  show ];
        [alert  release ];
        return;
    }
    // show keyboard and input view
    keyboard_view.hidden  = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [keyboard_view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-120, 320, 100)];
  
    [UIView commitAnimations];
    input_view.hidden = NO;
    self.one_pot = [NSMutableArray arrayWithCapacity:30];
    [listData1 addObject:one_pot];
    user = 1;
    [self cleanInputView];
    
}

- (IBAction)AddScore2:(id)sender {
    if (game_status != 1){
        UIAlertView  *alert = [[ UIAlertView   alloc ]  initWithTitle :@"Game not started."
                                                              message :@""
                                                             delegate : nil   cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
        [alert  show ];
        [alert  release ];
        return;
    }
    // show keyboard and input view
    keyboard_view.hidden  = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [keyboard_view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-120, 320, 100)];
    [UIView commitAnimations];
    input_view.hidden = NO;
    self.one_pot = [NSMutableArray arrayWithCapacity:30];
    [listData2 addObject:one_pot];
    user = 2;
    [self cleanInputView];
    
}

- (IBAction)add_score_red:(id) sender{
    UIButton *bsender = sender;
    int score = bsender.tag;
    if (bsender.tag > 0){
        NSLog(@"add boll");
        
        int size = [self.one_pot count];
        if (size >= 30){
            
            [[[[UIAlertView alloc] initWithTitle:@"error!" message:@"Cannot add more than 30 boll" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
            return;
        }
        int col = (size)%6;
        int row = (size)/6;
        
        if (row > 0){
            if (row < 4)
                input_view.frame = CGRectMake(10, 150, 300, 50*(row+1));
            [input_view setContentSize:CGSizeMake(300, 50*(row+1))];
        }
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10+45.0*col+2, 45.0*row+8, 41.0, 41.0)];
        NSString *image_name = @"";
        switch (bsender.tag){
            case 1: image_name = @"redboll.png";break;
            case 2: image_name = @"yellowboll.png";break; 
            case 3: image_name = @"greenboll.png";break; 
            case 4: image_name = @"brownboll.png";break; 
            case 5: image_name = @"blueboll.png";break; 
            case 6: image_name = @"pinkboll.png";break;
            case 7: image_name = @"blackboll.png";break; 
        }
        [btn setBackgroundImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:30.0];
        btn.titleLabel.font = font;
        [input_view addSubview:btn];
        if (row > 3)
            [input_view scrollRectToVisible:CGRectMake(10+40.0*col+2, 45.0*row+8, 36.0, 41.0) animated:true];

        [self.btsInInputView addObject:btn];
        [self.one_pot addObject:[NSNumber numberWithInt:score]];
        
       // [btn setTitle:[NSString stringWithFormat:@"%@", @"red"] forState:UIControlStateNormal];
        
        [btSave setTitle:@"Save" forState:UIControlStateNormal];
    }else if (bsender.tag == -1){
            NSLog(@"backspace");
        if ([self.one_pot count] > 0){
            [[self.btsInInputView lastObject] removeFromSuperview];
            [self.btsInInputView removeLastObject];
            [self.one_pot removeLastObject];
        }else{
            [btSave setTitle:@"Close" forState:UIControlStateNormal];
        }
    }else if (bsender.tag == -2){// save
        NSLog(@"save");
        if (user == 1){
            //[self.listData1 addObject:[NSString stringWithFormat:@"%d", sum]];
//            if (currentRow >= 0){
//              currentRow = -1;
//            }
//                else{
//                    [self.listData1 addObject:self.one_pot];
//                  
//                }
            [self.List1 reloadData];
        }
        else if (user ==2){
//            if (currentRow >= 0){
//                currentRow = -1;
//            }
//            else{
//                [self.listData2 addObject:self.one_pot];
//                
//            }
//            [self.listData2 addObject:[NSString stringWithFormat:@"%d", sum]];
   
            [self.List2 reloadData];
        }

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [keyboard_view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 100)];
        [UIView commitAnimations];
        keyboard_view.hidden  = YES;
        input_view.hidden = YES;
        
        if ([listData2 count]>5){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[listData2 count] inSection:0];
          //  int r = indexPath.row;
            [self.List2 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
        }
        if ([listData1 count]>5){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[listData1 count] inSection:0];
            //  int r = indexPath.row;
            [self.List1 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
        }
        
        // update total score
        [self update_score];
        
        
    }
}

- (void) update_score {
    int sum = 0;
    for (int i = 0; i< [listData1 count]; i++){
        NSMutableArray* pot = [listData1 objectAtIndex:i];
        for (int j = 0; j<[pot count]; j++){
            sum += [[pot objectAtIndex:j] integerValue];
        }
    }
    [self.score1 setText:[[NSString alloc] initWithFormat:@"%d", sum]];
    
    sum = 0;
    for (int i = 0; i< [listData2 count]; i++){
        NSMutableArray* pot = [listData2 objectAtIndex:i];
        for (int j = 0; j<[pot count]; j++){
            sum += [[pot objectAtIndex:j] integerValue];
        }
    }
    [self.score2 setText:[[NSString alloc] initWithFormat:@"%d", sum]];
    
    return;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return [self.listData1 count]+1;
        
    }else if (tableView.tag == 200) {
        return [self.listData2 count]+1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
#ifdef __IPHONE_3_0
        // Other styles you can try
        // UITableViewCellStyleSubtitle
        // UITableViewCellStyleValue1
        // UITableViewCellStyleValue2
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: SimpleTableIdentifier] autorelease];
#else
        cell = [[[UITableViewCell alloc] initWithFrame::CGRectZero
                                       reuseIdentifier: SimpleTableIdentifier] autorelease];
#endif
        
    }
    
    if (tableView.tag == 100) {        
        
        UIImage *image = [UIImage imageNamed:@"star.png"];
        UIImage *image2 = [UIImage imageNamed:@"star2.png"];
        cell.imageView.image = image;
        cell.imageView.highlightedImage = image2;
        
        NSUInteger row = [indexPath row];
        if (row < [listData1 count]){
            NSMutableArray *pot = [listData1 objectAtIndex:row];
            int sum = 0;
            for (int i = 0; i<[pot count]; i++){
               sum += [[pot objectAtIndex:i] integerValue];
            }
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%d", sum];
        }
        else{
             cell.textLabel.text = @"  ";
        }
//        cell.textLabel.font = [UIFont boldSystemFontOfSize:30];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
#ifdef __IPHONE_3_0    
        if (row < 7)
            cell.detailTextLabel.text = @"Mr. Disney";
        else
            cell.detailTextLabel.text = @"Mr. Tolkein";
#endif
        return cell;
        
        
    }else {
        
        UIImage *image = [UIImage imageNamed:@"star.png"];
        UIImage *image2 = [UIImage imageNamed:@"star2.png"];
        cell.imageView.image = image;
        cell.imageView.highlightedImage = image2;
        
        NSUInteger row = [indexPath row];
        if (row < [listData2 count]){
            NSMutableArray *pot = [listData2 objectAtIndex:row];
            int sum = 0;
            for (int i = 0; i<[pot count]; i++){
                sum += [[pot objectAtIndex:i] integerValue];
            }
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%d", sum];
        }else{
            cell.textLabel.text = @"  ";
        }
//        cell.textLabel.text = [listData2 objectAtIndex:row];
//        cell.textLabel.font = [UIFont boldSystemFontOfSize:30];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
#ifdef __IPHONE_3_0    
        if (row < 7)
            cell.detailTextLabel.text = @"Mr. Disney";
        else
            cell.detailTextLabel.text = @"Mr. Tolkein";
#endif
        return cell;
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}

#pragma mark -
#pragma mark Table Delegate Methods 
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger row = [indexPath row];
//    return row;
//}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSUInteger row = [indexPath row];
//    if (row == 0)
//        return nil;
    
    return indexPath; 
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (game_status != 1){
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        return;
//    }
    NSUInteger row = [indexPath row];
//    NSString *rowValue;
    
    // show keyboard and input view
    if (game_status == 1) // only show keyboard when game is started
        keyboard_view.hidden  = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [keyboard_view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-120, 320, 100)];
    [UIView commitAnimations];


    // show input boll in one pot
    input_view.hidden = NO;

    [self cleanInputView];
    if (tableView.tag == 100) {
            user = 1;
//        rowValue = [listData1 objectAtIndex:row];
        if (row >= [listData1 count]){
             self.one_pot = [NSMutableArray arrayWithCapacity:30];
            [listData1 addObject: one_pot];
//            currentRow = row;
        }else
            self.one_pot = [listData1 objectAtIndex:row];
    }else {
            user = 2;
       // rowValue = [listData2 objectAtIndex:row];
        if (row >= [listData2 count]){
            self.one_pot = [NSMutableArray arrayWithCapacity:30];
            [listData2 addObject: one_pot];
//            currentRow = row;
        }else
            self.one_pot = [listData2 objectAtIndex:row];
    }
    currentRow = row;
    
    // load bolls
    if (currentRow >=0 ){
        int row_number =[self.one_pot count]/6;
        input_view.frame = CGRectMake(10, 150, 300, 50*(row_number+1));
        [input_view setContentSize:CGSizeMake(300, 50*(row_number+1))];
        for (int i = 0; i< [self.one_pot count]; i++){
            int col = (i)%6;
            int row = (i)/6;
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(10+45.0*col+2, 45.0*row+8, 41.0, 41.0)];
            NSString *image_name = @"";
            switch ([[self.one_pot objectAtIndex:i] intValue]){
                case 1: image_name = @"redboll.png";break;
                case 2: image_name = @"yellowboll.png";break; 
                case 3: image_name = @"greenboll.png";break; 
                case 4: image_name = @"brownboll.png";break; 
                case 5: image_name = @"blueboll.png";break; 
                case 6: image_name = @"pinkboll.png";break;
                case 7: image_name = @"blackboll.png";break; 
            }
            [btn setBackgroundImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            UIFont *font = [UIFont systemFontOfSize:30.0];
            btn.titleLabel.font = font;
            [input_view addSubview:btn];

            if (row > 3)
                [input_view scrollRectToVisible:CGRectMake(10+40.0*col+2, 45.0*row+8, 36.0, 41.0) animated:true];
            
            [self.btsInInputView addObject:btn];

        }
    }
    
    
  /*  NSString *message = [[NSString alloc] initWithFormat:
                         @"You selected %@", rowValue];
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Row Selected!"
                          message:message 
                          delegate:nil 
                          cancelButtonTitle:@"Yes I Did" 
                          otherButtonTitles:nil];
    [alert show];
    
    [message release];
    [alert release];*/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//- (CGFloat)tableView:(UITableView *)tableView 
//heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}


// hide system keyboard when user click "return"
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
     return YES;
}
     
     
     
     
     
     
- (IBAction)onChangePlayer2:(id)sender {
    NSString *string = [self.Player2 text]; 
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  
    [ud setObject:string forKey:@"player2"];  

}
- (void)returnView
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}
@end
