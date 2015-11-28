//
//  GameViewController.m
//  volleyball
//
//  Created by JASON HARRIS on 11/3/15.
//  Copyright (c) 2015 Jason Harris. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import <Masonry.h>
#import "GameAndScoreDetails.h"

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

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GameAndScoreDetails sharedGameDataStore] resetGame];
    // Configure the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissThisViewController:)
                                                 name:@"dismissSelf"
                                               object:nil];
    
    
    
    
    SKView * skView = (SKView *)self.view;
    
    // debugging
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES; // CAN SLOW DOWN AND CRASH
    
    
        /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeFill;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    // Present the scene.
    [skView presentScene:scene];
}


-(void)dismissThisViewController:(id)selector
{
    [self dismissViewControllerAnimated:YES completion:^{
        // REMOVE NSNOTIFICATION
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
    
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
