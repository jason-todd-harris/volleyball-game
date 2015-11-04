//
//  GameViewController.m
//  volleyball
//
//  Created by JASON HARRIS on 11/3/15.
//  Copyright (c) 2015 Jason Harris. All rights reserved.
//

#import "MultiplayerViewController.h"
#import "gameAndScoreDetails.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end


@implementation MultiplayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.partyTime = [[PLPartyTime alloc] initWithServiceType:@"test"];   //@"volleyBallGame"];
    self.partyTime.delegate = self;
    [self.partyTime startAPaty];
    [self.partyTime joinParty];
    
    

}



- (void)partyTime:(PLPartyTime *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID
{
    NSLog(@"received data !!!");
    [self.delegate dataWasReceived:data];
    
}

-(void)partyTime:(PLPartyTime *)partyTime
            peer:(MCPeerID *)peer
    changedState:(MCSessionState)state
    currentPeers:(NSArray *)currentPeers
{
    NSLog(@"changed state %ld",(long)state);
    if(state == 2)
    {
        [self loadTheGame];
    } else if (state == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            UIAlertController *disconnectAlert = [UIAlertController alertControllerWithTitle:@"Game Over"
                                                                                     message:@"Opponent disconnected"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [disconnectAlert addAction:defaultAction];
            [self presentViewController:disconnectAlert animated:YES completion:nil];
        }];
    }
    
}


-(void)partyTime:(PLPartyTime *)partyTime
failedToJoinParty:(NSError *)error
{
    
    
}


-(void)loadTheGame
{
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES; // CAN SLOW DOWN AND CRASH
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.partyTime = self.partyTime;
    scene.multiPlayerVC = self;
    
    // Present the scene.
    [skView presentScene:scene];
    
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
