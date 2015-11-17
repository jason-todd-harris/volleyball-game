//
//  InitialViewController.m
//  volleyball
//
//  Created by JASON HARRIS on 11/4/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import "InitialViewController.h"
#import "MultiplayerViewController.h"
#import "gameAndScoreDetails.h"

@interface InitialViewController ()
@property (weak, nonatomic) IBOutlet UIButton *multiplayerClicked;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hostSwitch;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreenHeightandWidth];
    // Do any additional setup after loading the view.
    UIImage *backgroundSlice = [UIImage imageNamed:@"background-slice_small_ocean&sand"];
    CGFloat sizeRatio = backgroundSlice.size.height / self.screenHeight;
    backgroundSlice = [UIImage imageWithCGImage:backgroundSlice.CGImage scale:sizeRatio orientation:backgroundSlice.imageOrientation];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundSlice];
    
    
}

-(void)setScreenHeightandWidth
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.screenWidth = MAX(screenSize.width, screenSize.height);
    self.screenHeight = MIN(screenSize.width, screenSize.height);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[GameAndScoreDetails sharedGameDataStore] resetGame];
    if ([sender isEqual:self.multiplayerClicked])
    {
//        MultiplayerViewController *vc = [segue destinationViewController];
        [GameAndScoreDetails sharedGameDataStore].host = self.hostSwitch.selectedSegmentIndex;
    }

    
}

@end
