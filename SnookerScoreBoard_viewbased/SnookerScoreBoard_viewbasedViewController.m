//
//  SnookerScoreBoard_viewbasedViewController.m
//  SnookerScoreBoard_viewbased
//
//  Created by juweihua on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SnookerScoreBoard_viewbasedViewController.h"
#include <time.h>

@implementation SnookerScoreBoard_viewbasedViewController

@synthesize List1 = _List1;
@synthesize score1;
@synthesize score2;
@synthesize timer;
@synthesize List2 = _List2;
@synthesize listData1,listData2, one_pot, btsInInputView;

- (void)dealloc
{
    [List1 release];
    [List2 release];
    [score1 release];
    [score2 release];
    [timer release];
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
    currentRow = -1;
    [super viewDidLoad];
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
}

- (void) InitTableView{

    
    
    self.listData1 = [NSMutableArray arrayWithCapacity:20];
    self.listData2 = [NSMutableArray arrayWithCapacity:20];
  
    
    // configure table view
    [_List1 setDataSource:self];
    [_List1 setDelegate:self];
    _List1.scrollEnabled = YES;
    _List1.tag = 100;
//    //为视图增加边框      
//    _List1.clipsToBounds=YES;      
//    _List1.layer  cornerRadius=20.0;      
//    _List1.layer.borderWidth=10.0;      
//    _List1.layer.borderColor=[[UIColor blueColor] CGColor];      
//    
//    //为视图添加圆角
//    
//    _List1.layer.cornerRadius = 6;
//    _List1.layer.masksToBounds = YES;
    

    [self.view addSubview:_List1];   
    
    [_List2 setDataSource:self];
    [_List2 setDelegate:self];
    _List2.scrollEnabled = YES;
    _List2.tag = 200;
    [self.view addSubview:_List2];  
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
    [btn setTitle:[NSString stringWithFormat:@"%@", @"Save"] forState:UIControlStateNormal];
    [btn setTag:-2];
    [btn addTarget:self action:@selector(add_score_red:) forControlEvents:UIControlEventTouchUpInside];
    [keyboard_view addSubview:btn];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
  
    
    
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
    if ([self.listData1 count] >0)
        [self.listData1 removeAllObjects];
    if ([self.listData2 count]>0)
        [self.listData2 removeAllObjects];
    [self.List1 reloadData];
    [self.List2 reloadData];
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:(1.0)target:self selector:@selector(onTimer) userInfo:nil repeats:YES];	
    [t release];
    time(&t_start);
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
    // show keyboard and input view
    keyboard_view.hidden  = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [keyboard_view setFrame:CGRectMake(0, 360, 320, 100)];
    [UIView commitAnimations];
    input_view.hidden = NO;
    self.one_pot = [NSMutableArray arrayWithCapacity:30];
    [listData1 addObject:one_pot];
    user = 1;
    [self cleanInputView];
    
}

- (IBAction)AddScore2:(id)sender {
    // show keyboard and input view
    keyboard_view.hidden  = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [keyboard_view setFrame:CGRectMake(0, 360, 320, 100)];
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
        
    }else if (bsender.tag == -1){
            NSLog(@"backspace");
        if ([self.one_pot count] > 0){
            [[self.btsInInputView lastObject] removeFromSuperview];
            [self.btsInInputView removeLastObject];
            [self.one_pot removeLastObject];
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
        [keyboard_view setFrame:CGRectMake(0, 480, 320, 100)];
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
    
    NSUInteger row = [indexPath row];
//    NSString *rowValue;
    
    // show keyboard and input view
    keyboard_view.hidden  = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [keyboard_view setFrame:CGRectMake(0, 360, 320, 100)];
    [UIView commitAnimations];

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
     
     
     
     
     
     
@end
