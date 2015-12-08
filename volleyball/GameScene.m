//
//  GameScene.m
//  volleyball
//
//  Created by JASON HARRIS on 11/3/15.
//  Copyright (c) 2015 Jason Harris. All rights reserved.
//

#import "GameScene.h"
#import "GameAndScoreDetails.h"

@interface GameScene () <SKPhysicsContactDelegate, MultiplayerViewControllerDelegate>

//NODES AND SPRITES
@property (nonatomic, strong) SKShapeNode *showsTouchPoint;
@property (nonatomic, strong) SKSpriteNode *volleyBall;
@property (nonatomic, strong) SKNode *groundNodeLeft;
@property (nonatomic, strong) SKNode *groundNodeRight;
@property (nonatomic, strong) SKNode *wallNodeOne;
@property (nonatomic, strong) SKNode *wallNodeTwo;
@property (nonatomic, strong) SKLabelNode *scoreLabelNode;
@property (nonatomic, strong) SKLabelNode *restartButton;
@property (nonatomic, strong) SKNode *backButton;

//DEBUG NODES
@property (nonatomic, assign) bool debugMode;
@property (nonatomic, strong) SKLabelNode *ballPositionLabel;
@property (nonatomic, strong) SKLabelNode *heightWidthLabel;


//TRACKING VALUES (TOO MANY OF THESE)
@property (nonatomic, assign) bool allowBallHit; //GAME IN PLAY
@property (nonatomic, assign) bool gameStopped; //GAME STOPPED
@property (nonatomic, assign) bool readyToRestart; //READY TO RESTART

@property (nonatomic, assign) bool isMultiplayer;
@property (nonatomic, assign) bool lastTapper;
@property (nonatomic, assign) bool computerToHit;
@property (nonatomic, assign) NSUInteger consecutiveAIHits;

//@property (nonatomic, assign) bool allowReceivingData;

@property (nonatomic, assign) CGFloat screenSizeMultiplier;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, strong) NSString *gameFontName;
@property (nonatomic, assign) NSUInteger hostValue;
@property (nonatomic, strong) NSString *gameScore;
@property (nonatomic, strong) GameAndScoreDetails *localGameStore;
@property (nonatomic, assign) NSUInteger allowableHits;
@property (nonatomic, strong) NSString *whoShouldTap;

//SETTINGS
@property (nonatomic, assign) CGFloat ballDepthInSand;
@property (nonatomic, assign) CGFloat gravityValue;
@property (nonatomic, assign) NSUInteger frameCounter;
@property (nonatomic, strong) SKColor *skyColor;

@end


@implementation GameScene

// scene categories
static const uint32_t ballCategory = 1 << 0;
static const uint32_t fenceCategory = 1 << 1;
static const uint32_t worldCategory = 1 << 2;
static const uint32_t floorCategoryLeft = 1 << 3;
static const uint32_t floorCategoryRight = 1 << 4;
static const uint32_t ceilingCategory = 1 << 5;
// scene categories


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setScreenHeightandWidth];
    self.computerToHit = YES;
    self.debugMode = YES;
    self.hostValue = [GameAndScoreDetails sharedGameDataStore].host;
    [[GameAndScoreDetails sharedGameDataStore] resetGame];
    [GameAndScoreDetails sharedGameDataStore].host = self.hostValue;
    if([GameAndScoreDetails sharedGameDataStore].computerPlayer && self.hostValue == 2)
    {
        self.computerAI = YES;
    } else
    {
        self.computerAI = NO;
    }
    
    self.gameFontName = @"SpinCycleOT";
    self.physicsWorld.contactDelegate = self;
    self.screenSizeMultiplier = (1-self.view.frame.size.width / self.view.frame.size.height * 375 / 667.0);
    self.ballDepthInSand = self.screenHeight / 100;
    self.gravityValue = -2.5;
    self.allowableHits = 3;
    self.lastTapper = NO;
    self.frameCounter = 0;
    self.hostValue = [GameAndScoreDetails sharedGameDataStore].host;
    self.localGameStore = [GameAndScoreDetails sharedGameDataStore];
    self.isMultiplayer = (self.hostValue == 0 || self.hostValue == 1);
    //    self.allowReceivingData = YES;
    
    
    if (self.isMultiplayer)
    {
        self.multiPlayerVC.delegate = self;
    }
    
    
    [self setupSceneAndNodes];
    
    
    NSLog(@"%1.f width %1.f height self.frame",self.frame.size.width,self.frame.size.height);
    NSLog(@"%1.f width %1.f height self.view",self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"%1.f width %1.f height view.bounds",view.bounds.size.width,view.bounds.size.height);
    NSLog(@"%1.f width %1.f height self.height",self.size.width,self.size.height);
}


#pragma mark - EACH FRAME

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (self.lastTapper && self.frameCounter >2)
    {
        CGVector ballVector = self.volleyBall.physicsBody.velocity;
        [self sendDataToPlayer:ballVector
                      location:self.volleyBall.position
                   updateOrTap:@"update"
                  dataSendMode:MCSessionSendDataUnreliable];
        
        self.frameCounter = 0;
    }
    
    self.frameCounter ++;
    
    if (self.computerAI)
    {
        [self actionFromAI];
    }
    
    if (self.debugMode)
    {
        self.ballPositionLabel.text = [NSString stringWithFormat:@"x: %.0f y: %.0f",self.volleyBall.position.x , self.volleyBall.position.y];
    }
    
}

#pragma mark - AI setup

-(void)actionFromAI
{
    __block CGFloat ballCourtSide = self.volleyBall.position.x;
    __block CGFloat ballHeight = self.volleyBall.position.y;
    __block bool correctSideOfCourt = (self.frame.size.width/2 <= ballCourtSide); //IS THE BALL ON THE CORRECT SIDE OF THE COURT
    __block bool ballOnTheScreen = (self.frame.size.height >= ballHeight); //THE BALL SHOULDN'T BE ABOVE THE SCREEN
    __block bool lessThanThreeHits = ([GameAndScoreDetails sharedGameDataStore].rightPlayerHits < self.allowableHits); //HAVE THEY ALREADY HIT TOO MANY TIMES
    __block bool shouldHitBall = (correctSideOfCourt && lessThanThreeHits && ballOnTheScreen);
    if (shouldHitBall && (self.consecutiveAIHits < 4))
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ballCourtSide = self.volleyBall.position.x;
            ballHeight = self.volleyBall.position.y;
            correctSideOfCourt = (self.frame.size.width/2 <= ballCourtSide); //IS THE BALL ON THE CORRECT SIDE OF THE COURT
            ballOnTheScreen = (self.frame.size.height >= ballHeight); //THE BALL SHOULDN'T BE ABOVE THE SCREEN
            lessThanThreeHits = ([GameAndScoreDetails sharedGameDataStore].rightPlayerHits < self.allowableHits); //HAVE THEY ALREADY HIT TOO MANY TIMES
            shouldHitBall = (correctSideOfCourt && lessThanThreeHits && ballOnTheScreen);
            if (shouldHitBall && self.computerToHit)
            {
                UITouch *ballHit = [[UITouch alloc] init];
                self.physicsWorld.gravity = CGVectorMake(0.0, self.gravityValue);
                [self computerHitBall:ballHit];
                self.computerToHit = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.computerToHit = YES;
                });
            }
        });
    }
}


-(void)computerHitBall:(UITouch *)firstTouch
{
    CGPoint ballLocation = self.volleyBall.position;
    CGPoint touchLocation = pointAI(ballLocation, 1,-1);
    CGFloat forceHit = 90;
    CGPoint pointForRatio = pointSubtract(touchLocation, ballLocation);
    CGFloat xBallVector = forceHit * (pointForRatio.x / -ABS(pointForRatio.y));
    xBallVector = constrainFloat(-forceHit, forceHit, xBallVector);
    CGFloat yBallVector = forceHit * (pointForRatio.y / -ABS(pointForRatio.x));
    yBallVector = constrainFloat(-0.75*forceHit, forceHit, yBallVector);
    
    self.volleyBall.physicsBody.velocity = CGVectorMake(0,0);
    [self.volleyBall.physicsBody applyImpulse:CGVectorMake(xBallVector,yBallVector)];
    self.consecutiveAIHits ++;
}


#pragma mark - general game setup

-(void)setupSceneAndNodes
{
    [self removeAllChildren];
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.readyToRestart = NO;
    self.gameStopped = NO;
    [GameAndScoreDetails sharedGameDataStore].rightPlayerHits = 0;
    [GameAndScoreDetails sharedGameDataStore].leftPlayerHits = 0;
    
    
    //the touch point
    self.showsTouchPoint = [[SKShapeNode alloc] init];
    CGMutablePathRef ballPath = CGPathCreateMutable();
    CGPathAddArc(ballPath, NULL, 0,0, self.screenHeight / 30, 0, M_PI*2, YES);
    self.showsTouchPoint.path = ballPath;
    self.showsTouchPoint.lineWidth = 1.0;
    self.showsTouchPoint.fillColor = [SKColor darkGrayColor];
    self.showsTouchPoint.alpha = 0.5;
    self.showsTouchPoint.glowWidth = 0.0;
    self.showsTouchPoint.zPosition = 15;
    
    //SET UP VOLLEYBALL
    [self setUpVolleyBall];
    
    //SET UP COURT
    [self setUpTheCourtBounds];
    
    //SET UP GROUND METHOD
    [self setUpGround];
    
    //SET UP SCORE LABEL NODES
    [self scoreLabelNodesSetup];
    
    //SET UP FENCE / NET
    [self setUpFenceNodes];
    
    //SET UP PLAYER NAME LABELS
    [self setUpPlayerNames];
    
    //SET UP DEBUG NODES
    if (self.debugMode)
    {
        [self setUpDebugNodes];
        self.heightWidthLabel.text = [NSString stringWithFormat:@"width: %.0f height: %.0f", self.screenWidth , self.screenHeight];
    }
    
    //EXIT GAME BUTTON
    [self exitGameButton];
    
    self.allowBallHit = NO;
    
}


#pragma mark - set up scene nodes

-(void)setUpVolleyBall
{
    // volleyball
    SKTexture *volleyballTexture = [SKTexture textureWithImageNamed:@"Volleyball"];
    volleyballTexture.filteringMode = SKTextureFilteringNearest;
    self.volleyBall = [SKSpriteNode spriteNodeWithTexture:volleyballTexture];
    CGFloat volleyballScaleRatio = 1.0 / 7 * self.screenHeight / self.volleyBall.size.height; // volleyball size to screen size ratio
    [self.volleyBall setScale:volleyballScaleRatio];
    self.volleyBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.volleyBall.size.height/2];
    self.volleyBall.physicsBody.allowsRotation = YES;
    self.volleyBall.physicsBody.mass = 0.33;
    self.volleyBall.physicsBody.dynamic = YES;
    self.volleyBall.physicsBody.accessibilityLabel = @"volleyBall";
    self.volleyBall.physicsBody.categoryBitMask = ballCategory;
    self.volleyBall.physicsBody.collisionBitMask = fenceCategory | worldCategory | ceilingCategory | floorCategoryLeft | floorCategoryRight; // bounces off
    self.volleyBall.physicsBody.contactTestBitMask = fenceCategory | floorCategoryLeft; // notifications when collisions
    self.volleyBall.zPosition = 10;
    if ([GameAndScoreDetails sharedGameDataStore].theBallServer == LeftPlayerServe)
    {
        self.volleyBall.position = CGPointMake(self.screenWidth*1/6, self.screenHeight*3.5/5);
    } else {
        self.volleyBall.position = CGPointMake(self.screenWidth*5/6, self.screenHeight*3.5/5);
    }
    [self addChild:self.volleyBall];
}

-(void)setUpFenceNodes
{
    CGSize fenceSize = CGSizeMake(10, self.screenHeight/2.125);
    SKShapeNode *fenceShapeNode = [SKShapeNode shapeNodeWithRectOfSize:fenceSize cornerRadius:7];
    fenceShapeNode.fillColor = [SKColor whiteColor];
    fenceShapeNode.position = CGPointMake(self.screenWidth / 2.0, self.screenHeight / 3.0);
    CGSize smallerRectangle = CGSizeMake(fenceSize.width-3, fenceSize.height);
    fenceShapeNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallerRectangle];
    fenceShapeNode.physicsBody.categoryBitMask = fenceCategory;
    fenceShapeNode.physicsBody.contactTestBitMask = ballCategory;
    fenceShapeNode.physicsBody.dynamic = NO;
    fenceShapeNode.physicsBody.allowsRotation = NO;
    fenceShapeNode.zPosition = 5;
    [self addChild:fenceShapeNode];
}


-(void)setUpTheCourtBounds
{
    self.skyColor = [SKColor colorWithRed:112/255.0 green:200/255.0 blue:230/255.0 alpha:1.0];
    [self setBackgroundColor:self.skyColor];
    
    //wall one set up
    self.wallNodeOne = [SKNode node];
    self.wallNodeOne.position = CGPointMake(0, 0);
    self.wallNodeOne.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, self.frame.size.height*10)];
    self.wallNodeOne.physicsBody.categoryBitMask = worldCategory;
    self.wallNodeOne.physicsBody.dynamic = NO;
    [self addChild:self.wallNodeOne];
    
    //wall two set up
    self.wallNodeTwo = [SKNode node];
    self.wallNodeTwo.position = CGPointMake(self.frame.size.width, 0);
    self.wallNodeTwo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, self.frame.size.height*10)];
    self.wallNodeTwo.physicsBody.categoryBitMask = worldCategory;
    self.wallNodeTwo.physicsBody.dynamic = NO;
    [self addChild:self.wallNodeTwo];
    
    
    //CEILING SET UP
    SKNode *ceiling = [SKNode node];
    ceiling.position = CGPointMake(0, self.frame.size.height*2);
    ceiling.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width * 10, 1)];
    ceiling.physicsBody.categoryBitMask = ceilingCategory;
    ceiling.physicsBody.dynamic = NO;
    ceiling.physicsBody.allowsRotation = NO;
    [self addChild:ceiling];
    
    
}


-(void)setUpGround
{
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"background-slice_small_ocean&sand"];
    CGFloat heightRatio = self.size.height / groundTexture.size.height;
    CGFloat resultantHeight = 0;
    for(NSUInteger i = 0 ; i < 2 + self.screenWidth / groundTexture.size.width / heightRatio; i++)
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:heightRatio];
//        NSLog(@"%1.1f bg height",sprite.size.height);
//        NSLog(@"%1.1f bg width",sprite.size.width);
        sprite.position = CGPointMake(i*sprite.size.width , self.screenHeight / 2.0);
        sprite.zPosition = 0;
        resultantHeight = sprite.position.y;
        [self addChild:sprite];
    }
    
    //ground physics bodies set up
    
    self.groundNodeLeft = [SKNode node];
    self.groundNodeLeft.position = CGPointMake(self.frame.size.width / 4, self.screenHeight * 130 / 750 / 2.0 - self.ballDepthInSand); // CENTERS ONE QUARTER OF WIDTH AND MULTIPLY HEIGHT BY TWO BECAUSE OF SCALING
    self.groundNodeLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.screenWidth / 2, self.screenHeight * 130 / 750)]; // SUBTRACTING ALLOWS BALL TO SIT ON SAND
    self.groundNodeLeft.physicsBody.categoryBitMask = floorCategoryLeft;
    self.groundNodeLeft.physicsBody.contactTestBitMask = ballCategory;
    self.groundNodeLeft.physicsBody.dynamic = NO;
    [self addChild:self.groundNodeLeft];
    
    self.groundNodeRight = [SKNode node];
    self.groundNodeRight.position = CGPointMake(self.frame.size.width * 3 / 4, self.screenHeight * 130 / 750 / 2.0 - self.ballDepthInSand); // CENTERS ONE QUARTER OF WIDTH AND MULTIPLY HEIGHT BY TWO BECAUSE OF SCALING
    self.groundNodeRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.screenWidth / 2, self.screenHeight * 130 / 750 )]; // SUBTRACTING ALLOWS BALL TO SIT ON SAND
    self.groundNodeRight.physicsBody.categoryBitMask = floorCategoryRight;
    self.groundNodeRight.physicsBody.contactTestBitMask = ballCategory;
    self.groundNodeRight.physicsBody.dynamic = NO;
    [self addChild:self.groundNodeRight];

}

-(void)scoreLabelNodesSetup
{
    // SCORE LABEL SETUP
    self.scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:self.gameFontName];
    self.scoreLabelNode.zPosition = 100;
    self.scoreLabelNode.name = @"scoreLabelNode";
    self.scoreLabelNode.fontColor = [SKColor whiteColor];
    self.scoreLabelNode.fontSize = self.screenHeight / 7;
    self.scoreLabelNode.position = CGPointMake(self.screenWidth / 2, self.screenHeight / 19);
    [self updateScoreLabelNode];
    [self addChild:self.scoreLabelNode];
}

-(void)updateScoreLabelNode
{
    self.scoreLabelNode.text = [NSString stringWithFormat:@"%lu              %lu",(unsigned long)[GameAndScoreDetails sharedGameDataStore].leftPlayerScore,(unsigned long)[GameAndScoreDetails sharedGameDataStore].rightPlayerScore];
    
}

-(void)setUpPlayerNames
{
    CGFloat playerLabelFontSize = self.screenHeight / 10;
    CGFloat playerLabelHeight = self.screenHeight - self.screenHeight / 10;
    CGFloat playerLabelIndentation = self.screenWidth / 5;
    CGFloat playerLabelAlpha = 0.75;
    
    SKLabelNode *playerOneLabel = [SKLabelNode labelNodeWithFontNamed:self.gameFontName];
    playerOneLabel.zPosition = 1;
    playerOneLabel.text = @"PLAYER 1";
    playerOneLabel.fontColor = [SKColor whiteColor];
    playerOneLabel.fontSize = playerLabelFontSize;
    playerOneLabel.alpha = playerLabelAlpha;
    playerOneLabel.position = CGPointMake(playerLabelIndentation, playerLabelHeight);
    
    
    SKLabelNode *playerTwoLabel = [SKLabelNode labelNodeWithFontNamed:self.gameFontName];
    playerTwoLabel.zPosition = 1;
    playerTwoLabel.text = @"PLAYER 2";
    playerTwoLabel.fontColor = [SKColor whiteColor];
    playerTwoLabel.fontSize = playerLabelFontSize;
    playerTwoLabel.alpha = playerLabelAlpha;
    playerTwoLabel.position = CGPointMake(self.screenWidth -  playerLabelIndentation, playerLabelHeight);
    
    
    if(self.hostValue == 0)
    {
        playerTwoLabel.alpha = 0.25;
    } else if (self.hostValue == 1)
    {
        playerOneLabel.alpha = 0.25;
    }
    
    
    [self addChild:playerOneLabel];
    [self addChild:playerTwoLabel];
    
    
    
    
}


#pragma mark - restart

-(void)placeRestartGameButton
{
    self.gameStopped = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([GameAndScoreDetails sharedGameDataStore].theBallServer)
        {
            self.whoShouldTap = @"PLAYER 2 - ";
        } else
        {
            self.whoShouldTap = @"PLAYER 1 - ";
        }
        
        
        
        self.restartButton = [SKLabelNode labelNodeWithFontNamed:@"SpinCycleOT"];
        self.restartButton.position = CGPointMake(self.frame.size.width/2,self.frame.size.height * 2.75 / 4);
        self.restartButton.zPosition = 100;
        self.restartButton.text = [NSString stringWithFormat:@"%@TAP TO RESET SERVE",self.whoShouldTap];
        self.restartButton.name = @"resetGameNode";
        self.restartButton.fontColor = [SKColor whiteColor];
        self.restartButton.fontSize = self.screenWidth / 18.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if((self.hostValue == self.localGameStore.theBallServer) || self.hostValue == 2)
            {
                self.readyToRestart = YES;
                [GameAndScoreDetails sharedGameDataStore].leftPlayerHits = 0;
                [GameAndScoreDetails sharedGameDataStore].rightPlayerHits = 0;
            }
            
        });
        [self addChild:self.restartButton];
    });
}


#pragma mark - debug items
-(void)setUpDebugNodes
{
    // BALL POSITION DEBUGGER
    self.ballPositionLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Nue"];
    self.ballPositionLabel.zPosition = 100;
    self.ballPositionLabel.name = @"ballPositionLabel";
    self.ballPositionLabel.fontColor = [SKColor whiteColor];
    self.ballPositionLabel.fontSize = self.screenHeight /15;
    self.ballPositionLabel.position = CGPointMake(self.screenWidth / 7, self.screenHeight / 5);
    [self addChild:self.ballPositionLabel];
    
    // BALL SCREENSIZE
    self.heightWidthLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Nue"];
    self.heightWidthLabel.zPosition = 100;
    self.heightWidthLabel.name = @"heightWidthLabel";
    self.heightWidthLabel.fontColor = [SKColor whiteColor];
    self.heightWidthLabel.fontSize = self.screenHeight /15;
    self.heightWidthLabel.position = CGPointMake(self.screenWidth *5.5 / 7, self.screenHeight / 5);
    [self addChild:self.heightWidthLabel];
    
    
}

#pragma mark - Touch and Hitting

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *firstTouch = touches.anyObject;
    
    if([self shouldHitExitButton:firstTouch])
    {
        [self removeFromParent];
        [self.view presentScene:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissSelf"
                                                            object:self];
        [[GameAndScoreDetails sharedGameDataStore] resetGame];
        
    }
    
    if([self shouldBallBeHit:firstTouch] && self.allowBallHit)
    {
        [self hitTheVolleyBall:firstTouch];
        //SHOWS WHERE TOUCH HAPPENED
        CGPoint touchLocation = [firstTouch locationInNode:self];
        [self removeChildrenInArray:@[self.showsTouchPoint]];
        self.showsTouchPoint.position = touchLocation;
        [self addChild:self.showsTouchPoint];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeChildrenInArray:@[self.showsTouchPoint]];
        });
    }
    
    if(self.gameStopped && self.readyToRestart)
    {
        [self setupSceneAndNodes];
        
        [self sendDataToPlayer:CGVectorMake(0, 0)
                      location:self.volleyBall.position
                   updateOrTap:@"restartGame"
                  dataSendMode:MCSessionSendDataReliable];
    }
    
}


-(bool)shouldBallBeHit:(UITouch *)firstTouch
{
    if(self.gameStopped)
    {
        return NO;
    }
    CGPoint ballTouch = [firstTouch locationInNode:self.volleyBall];
    CGFloat xDistance = ballTouch.x;
    CGFloat yDistance = ballTouch.y;
    CGFloat heightVolleyball = self.volleyBall.size.height;
    CGFloat ballCourtSide = self.volleyBall.position.x;
    BOOL shouldHitBall = 1;
    
    
    if(self.hostValue ==0)  // IF PLAYER ONE
    {
        bool correctSideOfCourt = (self.frame.size.width/2 >= ballCourtSide);  //IS THE BALL ON THE CORRECT SIDE OF THE COURT
        bool lessThanThreeHits = ([GameAndScoreDetails sharedGameDataStore].leftPlayerHits < self.allowableHits); //HAVE THEY ALREADY HIT TOO MANY TIMES
        shouldHitBall = (correctSideOfCourt && lessThanThreeHits);
    } else if (self.hostValue == 1)  //IF PLAYER 2
    {
        bool correctSideOfCourt = (self.frame.size.width/2 <= ballCourtSide); //IS THE BALL ON THE CORRECT SIDE OF THE COURT
        bool lessThanThreeHits = ([GameAndScoreDetails sharedGameDataStore].rightPlayerHits < self.allowableHits); //HAVE THEY ALREADY HIT TOO MANY TIMES
        shouldHitBall = (correctSideOfCourt && lessThanThreeHits);
    }
    
    bool closeToTheBall = (ABS(xDistance) < heightVolleyball*2.0) && (ABS(yDistance) < heightVolleyball*2.0);
    
    
    if (closeToTheBall && shouldHitBall)
    {
        if(self.allowBallHit || !self.readyToRestart)
        {
            self.physicsWorld.gravity = CGVectorMake(0.0, self.gravityValue);
            self.allowBallHit = YES;
        }
    }
    
    if (self.frame.size.width/2 > ballCourtSide && shouldHitBall && closeToTheBall)
    {
        [self.localGameStore leftPlayerHitTheBall];
        self.localGameStore.rightPlayerHits = 0;
    } else if (self.frame.size.width/2 < ballCourtSide && shouldHitBall && closeToTheBall)
    {
        [self.localGameStore rightPlayerHitTheBall];
        self.localGameStore.leftPlayerHits = 0;
    }
    
    return closeToTheBall && shouldHitBall;
}


-(void)hitTheVolleyBall:(UITouch *)firstTouch
{
    CGPoint ballLocation = self.volleyBall.position;
    CGPoint touchLocation = [firstTouch locationInNode:self];
    CGFloat forceHit = 90;
    
    CGPoint pointForRatio = pointSubtract(touchLocation, ballLocation);
    CGFloat xBallVector = forceHit * (pointForRatio.x / -ABS(pointForRatio.y));
    xBallVector = constrainFloat(-forceHit, forceHit, xBallVector);
    CGFloat yBallVector = forceHit * (pointForRatio.y / -ABS(pointForRatio.x));
    yBallVector = constrainFloat(-0.75*forceHit, forceHit, yBallVector);
    
    self.volleyBall.physicsBody.velocity = CGVectorMake(0,0); // ball mass is 0.26420798897743225
    [self.volleyBall.physicsBody applyImpulse:CGVectorMake(xBallVector,yBallVector)]; // bird mass 0.02010619267821312
    [self sendDataToPlayer:CGVectorMake(xBallVector,yBallVector)
                  location:ballLocation
               updateOrTap:@"tap"
              dataSendMode:MCSessionSendDataReliable];
    
    self.lastTapper = YES;
    if(self.computerAI)
    {
        self.consecutiveAIHits = 0;
        [GameAndScoreDetails sharedGameDataStore].rightPlayerHits ++;
    }
}


#pragma mark - contact made

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
    bool leftSideFall = (contact.bodyA.categoryBitMask == floorCategoryLeft || contact.bodyB.categoryBitMask == floorCategoryLeft);
    bool rightSideFall = (contact.bodyA.categoryBitMask == floorCategoryRight || contact.bodyB.categoryBitMask == floorCategoryRight);
    bool netHit = (contact.bodyA.categoryBitMask == fenceCategory || contact.bodyB.categoryBitMask == fenceCategory);
    
    if(leftSideFall || rightSideFall)
    {
        self.lastTapper = NO;
    }
    
    
    if (leftSideFall)
    {
        if(!self.gameStopped)
        {
            [self flashBackgroundScreen:nil];
            [[GameAndScoreDetails sharedGameDataStore] rightPlayerScored];
            [self placeRestartGameButton];
        }
        NSLog(@"Left side Hit");
        self.gameStopped = YES;
        
    } else if (rightSideFall)
    {
        if(!self.gameStopped)
        {
            [self flashBackgroundScreen:nil];
            [[GameAndScoreDetails sharedGameDataStore] leftPlayerScored];
            [self placeRestartGameButton];
        }
        NSLog(@"Right side Hit");
        self.gameStopped = YES;
    } else if (netHit)
    {
        [self flashBackgroundScreen:[SKColor grayColor]];
        NSLog(@"Net was hit");
    }
    [self updateScoreLabelNode];
    
}


-(void)flashBackgroundScreen:(SKColor *)color
{
    __block NSUInteger count = 3;
    [self removeActionForKey:@"flash"];
    [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        self.backgroundColor = [SKColor redColor];
        if (color)
        {
            self.backgroundColor = color;
            count = 1;
        }
    }], [SKAction waitForDuration:0.1], [SKAction runBlock:^{
        self.backgroundColor = _skyColor;
    }], [SKAction waitForDuration:0.1]]] count:count], [SKAction runBlock:^{
        //UPON COMPLETION
    }]]] withKey:@"flash"];
}


#pragma mark - multiplayer handling

-(void)dataWasReceived:(NSData *)data
{

    NSDictionary *gameDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *stringVector = gameDictionary[@"vector"];
    NSString *stringPoint = gameDictionary[@"point"];
    NSString *updateOrTap = gameDictionary[@"updateOrTap"];
    NSNumber *otherLeftScore = gameDictionary[@"leftScore"];
    NSNumber *otherRightScore = gameDictionary[@"rightScore"];
    
    CGVector hitVector = CGVectorFromString(stringVector);
    CGPoint ballLocalation = CGPointFromString(stringPoint);
    
    if(!self.allowBallHit && [updateOrTap isEqualToString:@"tap"])
    {
        self.physicsWorld.gravity = CGVectorMake(0.0, self.gravityValue);
    }
    
    
    if (self.lastTapper == NO && ![updateOrTap isEqualToString:@"restartGame"])
    {
        [self otherMultiplayerTap:hitVector location:ballLocalation updateOrTap:updateOrTap];
        [GameAndScoreDetails sharedGameDataStore].leftPlayerHits = 0;
        [GameAndScoreDetails sharedGameDataStore].rightPlayerHits = 0;
        
    } else if ([updateOrTap isEqualToString:@"tap"])
    {
        [self otherMultiplayerTap:hitVector location:ballLocalation updateOrTap:updateOrTap];
        self.lastTapper = NO;
    } else if ([updateOrTap isEqualToString:@"restartGame"])
    {
        [GameAndScoreDetails sharedGameDataStore].leftPlayerScore = otherLeftScore.unsignedIntegerValue;
        [GameAndScoreDetails sharedGameDataStore].rightPlayerScore = otherRightScore.unsignedIntegerValue;
        [self setupSceneAndNodes];
    }
    
    
    
}

-(void)otherMultiplayerTap:(CGVector)vector location:(CGPoint)location updateOrTap:(NSString *)type
{
    self.volleyBall.position = location;
    if([type isEqualToString:@"tap"])
    {
        self.volleyBall.physicsBody.velocity = CGVectorMake(0,0);
        [self.volleyBall.physicsBody applyImpulse:vector];
    } else
    {
        self.volleyBall.physicsBody.velocity = vector;
    }
    
}


-(void)sendDataToPlayer:(CGVector)hitVector
               location:(CGPoint)location
            updateOrTap:(NSString *)type
           dataSendMode:(MCSessionSendDataMode)dataSendMode
{
    if (!dataSendMode)
    {
        dataSendMode = MCSessionSendDataReliable;
    }
    
    if (self.hostValue != 2) // && !self.allowBallHit)
    {
        NSString *stringVector = NSStringFromCGVector(hitVector);
        NSString *stringPoint = NSStringFromCGPoint(location);
        NSDictionary *gameDictionary = @{@"vector" : stringVector,
                                         @"point" : stringPoint,
                                         @"updateOrTap" : type,
                                         @"leftScore" : @([GameAndScoreDetails sharedGameDataStore].leftPlayerScore),
                                         @"rightScore" : @([GameAndScoreDetails sharedGameDataStore].rightPlayerScore)};
        NSData *sendingData = [NSKeyedArchiver archivedDataWithRootObject:gameDictionary];
        [self.partyTime sendData:sendingData withMode:(dataSendMode) error:nil];
    }
}

//-(void)temporarilyTurnOffDataReceiving:(NSUInteger)xSeconds
//{
//    if(!xSeconds)
//    {
//        xSeconds = 0.1;
//    }
//    self.allowReceivingData = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(xSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.allowReceivingData = YES;
//    });
//    
//}

#pragma mark - exit buttons

-(void)exitGameButton
{
    SKTexture *backButtonTexture = [SKTexture textureWithImageNamed:@"beachvolleyball-exitbutton"];
    self.backButton = [SKSpriteNode spriteNodeWithTexture:backButtonTexture];
    
    CGFloat scaleRatio =  self.screenHeight/backButtonTexture.size.height / 8;
    [self.backButton setScale:scaleRatio];
    self.backButton.position = CGPointMake(self.backButton.frame.size.height*2/3,self.backButton.frame.size.height*2/3);
    self.backButton.zPosition = 102;
    self.backButton.name = @"exitButtonNode";
    self.backButton.alpha = 0.90;
    [self addChild:self.backButton];
    
    SKAction *rotate = [SKAction rotateByAngle:M_PI duration:0];
    [self.backButton runAction:rotate];
    
}

-(BOOL)shouldHitExitButton:(UITouch *)firstTouch
{
    
    CGPoint exitTouch = [firstTouch locationInNode:self.backButton];
    CGFloat xDistance = exitTouch.x;
    CGFloat yDistance = exitTouch.y;
    CGFloat heightExit = self.backButton.frame.size.height;
    
    bool closeToBackButton = (ABS(xDistance) < heightExit) && (ABS(yDistance) < heightExit);
    
    return closeToBackButton;
}




#pragma mark - helpers

CGFloat constrainFloat(CGFloat min, CGFloat max, CGFloat value) {
    if( value > max ) {
        return max;
    } else if( value < min ) {
        return min;
    } else {
        return value;
    }
}

-(void)setScreenHeightandWidth
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.screenWidth = MAX(screenSize.width, screenSize.height);
    self.screenHeight = MIN(screenSize.width, screenSize.height);
}




#pragma mark - Transformations
static inline CGPoint transformForHit(CGPoint a , CGPoint b) {
    
    return CGPointMake(a.x, b.y);
}

static inline CGPoint pointAddition(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint pointAI(CGPoint a, float x, float y) {
    return CGPointMake(a.x + x, a.y + y);
}

static inline CGPoint pointSubtract(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint pointMultiply(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float Length(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint pointNormalize(CGPoint a) {
    float length = Length(a);
    return CGPointMake(a.x / length, a.y / length);
}


@end
