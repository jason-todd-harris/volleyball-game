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
@property (nonatomic, strong) SKShapeNode *showsTouchPoint;
@property (nonatomic, strong) SKSpriteNode *volleyBall;
@property (nonatomic, strong) SKColor *skyColor;
@property (nonatomic, strong) SKNode *groundNodeLeft;
@property (nonatomic, strong) SKNode *groundNodeRight;
@property (nonatomic, strong) SKNode *wallNodeOne;
@property (nonatomic, strong) SKNode *wallNodeTwo;
@property (nonatomic, assign) CGFloat screenSizeMultiplier;
@property (nonatomic, assign) CGFloat ballDepthInSand;
@property (nonatomic, assign) bool gameInPlay;
@property (nonatomic, assign) BOOL isMultiplayer;
@property (nonatomic, assign) NSUInteger hostValue;
@property (nonatomic, assign) CGFloat gravityValue;


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
    self.physicsWorld.contactDelegate = self;
    self.screenSizeMultiplier = (1-self.view.frame.size.width / self.view.frame.size.height * 375 / 667.0);
    self.ballDepthInSand = 10.0;
    self.gravityValue = -2.5;
    self.hostValue = [GameAndScoreDetails sharedGameDataStore].host;
    self.skyColor = [SKColor colorWithRed:112/255.0 green:200/255.0 blue:230/255.0 alpha:1.0];
//    self.skyColor = [SKColor blackColor]; //black color for troubleshooting
    [self setBackgroundColor:self.skyColor];
    self.multiPlayerVC.delegate = self;
    
    
    
    [self setupSceneAndNodes];
    
    
    NSLog(@"%1.f width %1.f height self.frame",self.frame.size.width,self.frame.size.height);
    NSLog(@"%1.f width %1.f height self.view",self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"%1.f width %1.f height view.bounds",view.bounds.size.width,view.bounds.size.height);
    NSLog(@"%1.f width %1.f height [UIFrame mainScreen].bounds ",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width);
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}



-(void)setupSceneAndNodes
{
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
    //the touch point
    self.showsTouchPoint = [[SKShapeNode alloc] init];
    CGMutablePathRef ballPath = CGPathCreateMutable();
    CGPathAddArc(ballPath, NULL, 0,0, 15, 0, M_PI*2, YES);
    self.showsTouchPoint.path = ballPath;
    self.showsTouchPoint.lineWidth = 1.0;
    self.showsTouchPoint.fillColor = [SKColor darkGrayColor];
    self.showsTouchPoint.alpha = 0.5;
    self.showsTouchPoint.glowWidth = 0.0;
    self.showsTouchPoint.zPosition = 15;
    
    
    // volleyball
    SKTexture *volleyballTexture = [SKTexture textureWithImageNamed:@"Volleyball"];
    volleyballTexture.filteringMode = SKTextureFilteringNearest;
    
    self.volleyBall = [SKSpriteNode spriteNodeWithTexture:volleyballTexture];
    self.volleyBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.volleyBall.size.height/2];
    self.volleyBall.physicsBody.allowsRotation = YES;
    self.volleyBall.physicsBody.dynamic = YES;
    self.volleyBall.physicsBody.accessibilityLabel = @"volleyBall";
    self.volleyBall.physicsBody.categoryBitMask = ballCategory;
    self.volleyBall.physicsBody.collisionBitMask = fenceCategory | worldCategory | ceilingCategory | floorCategoryLeft | floorCategoryRight; // bounces off
    self.volleyBall.physicsBody.contactTestBitMask = fenceCategory | floorCategoryLeft; // notifications when collisions
    self.volleyBall.zPosition = 10;
    self.volleyBall.position = CGPointMake(self.size.width*1/6, self.size.height*3/5);
    [self addChild:self.volleyBall];
    
    //ground set up
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Ground"];
    //    groundTexture.filteringMode = SKTextureFilteringNearest;
    CGFloat resultantHeight = 0;
    for(NSUInteger i = 0 ; i < 2 + self.frame.size.width/(groundTexture.size.width*2); i++)
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:2.0]; //CHECK THIS OUT
        sprite.position = CGPointMake(i*sprite.size.width, sprite.size.height / 2 + groundTexture.size.height * 2 - (self.screenSizeMultiplier* self.view.frame.size.height)); //CHECK THIS OUT
        sprite.zPosition = 5;
        resultantHeight = sprite.position.y;
        [self addChild:sprite];
    }
    
    //ground physics bodies set up
    
    self.groundNodeLeft = [SKNode node];
    self.groundNodeLeft.position = CGPointMake(self.frame.size.width / 4, resultantHeight - 10 ); // CENTERS ONE QUARTER OF WIDTH AND MULTIPLY HEIGHT BY TWO BECAUSE OF SCALING
    self.groundNodeLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width / 2, groundTexture.size.height*2 - self.ballDepthInSand)]; // SUBTRACTING ALLOWS BALL TO SIT ON SAND
    self.groundNodeLeft.physicsBody.categoryBitMask = floorCategoryLeft;
    self.groundNodeLeft.physicsBody.contactTestBitMask = ballCategory;
    self.groundNodeLeft.physicsBody.dynamic = NO;
    [self addChild:self.groundNodeLeft];
    
    self.groundNodeRight = [SKNode node];
    self.groundNodeRight.position = CGPointMake(self.frame.size.width * 3 / 4, resultantHeight - 10 ); // CENTERS ONE QUARTER OF WIDTH AND MULTIPLY HEIGHT BY TWO BECAUSE OF SCALING
    self.groundNodeRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width / 2, groundTexture.size.height*2 - self.ballDepthInSand)]; // SUBTRACTING ALLOWS BALL TO SIT ON SAND
    self.groundNodeRight.physicsBody.categoryBitMask = floorCategoryRight;
    self.groundNodeRight.physicsBody.contactTestBitMask = ballCategory;
    self.groundNodeRight.physicsBody.dynamic = NO;
    [self addChild:self.groundNodeRight];
    
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
    
    
    //fence texture - this is all BS, using an arbitrary texture and height is all fudged
    SKTexture *fenceTexture = [SKTexture textureWithImageNamed:@"yellow+dot+med"];
    fenceTexture.filteringMode = SKTextureFilteringNearest;
    
    for(NSUInteger i = 0 ; i < 2 + self.frame.size.height/(fenceTexture.size.height*2)-2; i++)
    {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:fenceTexture];
        sprite.position = CGPointMake(self.frame.size.width / 2, (sprite.size.height)*i - 5); // subtraction places yellow balls closer together
        [self addChild:sprite];
    }
    
    
    //fence node setup - this seems to be alright
    SKNode *fenceNode = [SKNode node];
    fenceNode.position = CGPointMake(self.frame.size.width/2 , 0); // NODE POSITION
    fenceNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, self.frame.size.height/2) center:(CGPointMake(0, self.frame.size.height/4))]; //where to center this IN THE NODE
    fenceNode.physicsBody.categoryBitMask = fenceCategory;
    fenceNode.physicsBody.contactTestBitMask = ballCategory;
    fenceNode.physicsBody.dynamic = NO;
    fenceNode.physicsBody.allowsRotation = NO;
    [self addChild:fenceNode];
    
    self.gameInPlay = NO;
    
}

#pragma mark - Touch and Hitting

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *firstTouch = touches.anyObject;
    if(!self.gameInPlay)
    {
        self.physicsWorld.gravity = CGVectorMake(0.0, self.gravityValue);
        self.gameInPlay = YES;
    }
    
    CGPoint ballTouch = [firstTouch locationInNode:self.volleyBall];
    CGFloat xDistance = ballTouch.x;
    CGFloat yDistance = ballTouch.y;
    CGFloat heightVolleyball = self.volleyBall.size.height;
    if( (ABS(xDistance) < heightVolleyball*1.5) && (ABS(yDistance) < heightVolleyball*1.5) )
       {
        [self hitTheVolleyBall:firstTouch];
       }
    
    CGPoint touchLocation = [firstTouch locationInNode:self];
    [self removeChildrenInArray:@[self.showsTouchPoint]];
    self.showsTouchPoint.position = touchLocation;
    [self addChild:self.showsTouchPoint];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeChildrenInArray:@[self.showsTouchPoint]];
    });
}

-(void)dataWasReceived:(NSData *)data
{
    if(!self.gameInPlay)
    {
        self.physicsWorld.gravity = CGVectorMake(0.0, self.gravityValue);
        self.gameInPlay = YES;
    }
    NSDictionary *gameDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *stringVector = gameDictionary[@"vector"];
    NSString *stringPoint = gameDictionary[@"point"];
    CGVector hitVector = CGVectorFromString(stringVector);
    CGPoint ballLocalation = CGPointFromString(stringPoint);
    [self otherMultiplayerTap:hitVector location:ballLocalation];
    
}

-(void)otherMultiplayerTap:(CGVector)vector location:(CGPoint)location
{
    self.volleyBall.position = location;
    self.volleyBall.physicsBody.velocity = CGVectorMake(0,0);
    [self.volleyBall.physicsBody applyImpulse:vector];
    
}


-(void)sendDataToPlayer:(CGVector)hitVector location:(CGPoint)location
{
    NSString *stringVector = NSStringFromCGVector(hitVector);
    NSString *stringPoint = NSStringFromCGPoint(location);
    NSDictionary *gameDictionary = @{@"vector" : stringVector,
                                     @"point" : stringPoint};
    NSData *sendingData = [NSKeyedArchiver archivedDataWithRootObject:gameDictionary];
    [self.partyTime sendData:sendingData withMode:(MCSessionSendDataReliable) error:nil];
    
}

-(void)hitTheVolleyBall:(UITouch *)firstTouch
{
    CGPoint ballLocation = self.volleyBall.position;
    CGPoint touchLocation = [firstTouch locationInNode:self];
    CGFloat forceHit = 100;
    
    CGPoint pointForRatio = pointSubtract(touchLocation, ballLocation);
    CGFloat xBallVector = forceHit * (pointForRatio.x / -ABS(pointForRatio.y));
    xBallVector = constrainFloat(-forceHit, forceHit, xBallVector);
    CGFloat yBallVector = forceHit * (pointForRatio.y / -ABS(pointForRatio.x));
    yBallVector = constrainFloat(-0.75*forceHit, forceHit, yBallVector);
    
    self.volleyBall.physicsBody.velocity = CGVectorMake(0,0); // ball mass is 0.26420798897743225
    [self.volleyBall.physicsBody applyImpulse:CGVectorMake(xBallVector,yBallVector)]; // bird mass 0.02010619267821312
    [self sendDataToPlayer:CGVectorMake(xBallVector,yBallVector) location:ballLocation];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    // Flash background if contact is detected
    
    
    bool leftSideFall = (contact.bodyA.categoryBitMask == floorCategoryLeft || contact.bodyB.categoryBitMask == floorCategoryLeft);
    bool rightSideFall = (contact.bodyA.categoryBitMask == floorCategoryRight || contact.bodyB.categoryBitMask == floorCategoryRight);
    bool netHit = (contact.bodyA.categoryBitMask == fenceCategory || contact.bodyB.categoryBitMask == fenceCategory);
    
    if (leftSideFall)
    {
        if(self.gameInPlay)
        {
            [self flashBackgroundScreen:nil];
        }
        NSLog(@"Left side Hit");
        self.gameInPlay = NO;
        
    } else if (rightSideFall)
    {
        if(self.gameInPlay)
        {
            [self flashBackgroundScreen:nil];
        }
        NSLog(@"Right side Hit");
        self.gameInPlay = NO;
    } else if (netHit)
    {
        if(self.gameInPlay)
        {
            [self flashBackgroundScreen:[SKColor grayColor]];
        }
        NSLog(@"Net was hit");
        
        
    }
    
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
    }], [SKAction waitForDuration:0.05], [SKAction runBlock:^{
        self.backgroundColor = _skyColor;
    }], [SKAction waitForDuration:0.05]]] count:count], [SKAction runBlock:^{
        //AFTER ANIMATION IS COMPLETE
    }]]] withKey:@"flash"];
}



#pragma mark - math helper

CGFloat constrainFloat(CGFloat min, CGFloat max, CGFloat value) {
    if( value > max ) {
        return max;
    } else if( value < min ) {
        return min;
    } else {
        return value;
    }
}



#pragma mark - Transformations
static inline CGPoint transformForHit(CGPoint a , CGPoint b) {
    
    return CGPointMake(a.x, b.y);
}

static inline CGPoint pointAddition(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
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
