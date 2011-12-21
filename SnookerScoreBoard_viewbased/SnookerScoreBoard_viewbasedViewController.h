//
//  SnookerScoreBoard_viewbasedViewController.h
//  SnookerScoreBoard_viewbased
//
//  Created by juweihua on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnookerScoreBoard_viewbasedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIScrollView* input_view; // the view for display input score
    
    UIView* keyboard_view; // the view for display keyboard
    
    UITableView *List1;
    UILabel *score1;
    UILabel *score2;
    UILabel *timer;
    UIButton *btStart;
    UITableView *List2;
    
    NSMutableArray *btsInInputView;
    NSMutableArray *one_pot;
    NSMutableArray *listData1;
    NSMutableArray *listData2;
    int user; // player1 or play 2
    int currentRow;
    time_t t_start;
    int game_status; // 0: init value, 1: started, 2: over
    UIButton *btSave; // save button in keyboard
    NSTimer* game_timer;
    UITextField *Player1;
    UITextField *Player2;
}
- (IBAction)onChangePlayer2:(id)sender;
@property (nonatomic, retain) IBOutlet UITableView *List1;

@property (nonatomic, retain) IBOutlet UILabel *score1;
@property (nonatomic, retain) IBOutlet UILabel *score2;
@property (nonatomic, retain) IBOutlet UILabel *timer;
@property (nonatomic, retain) IBOutlet UIButton *btStart;

@property (nonatomic, retain) IBOutlet UITableView *List2;
@property (nonatomic, retain) NSMutableArray *listData1;
@property (nonatomic, retain) NSMutableArray *listData2;
@property (nonatomic, retain) NSMutableArray *one_pot;
@property (nonatomic, retain) NSMutableArray *btsInInputView;
@property (nonatomic, retain) NSTimer *game_timer;
@property (nonatomic, retain) IBOutlet UITextField *Player1;
@property (nonatomic, retain) IBOutlet UITextField *Player2;

- (IBAction)onRestart:(id)sender;
- (IBAction)onShare:(id)sender;
- (IBAction)onChangePlay1Name:(id)sender;

- (IBAction)AddScore1:(id)sender;
- (IBAction)AddScore2:(id)sender;
- (void) InitTableView;
- (IBAction)add_score_red:(id) sender;
- (void) InitKeyboardView;
- (void) cleanInputView;
- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (void) update_score;
- (void) onTimer;

// view event
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

@end