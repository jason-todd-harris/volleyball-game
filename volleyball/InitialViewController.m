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

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
