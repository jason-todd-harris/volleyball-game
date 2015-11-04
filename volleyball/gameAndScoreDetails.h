//
//  GameAndScoreDetails.h
//  volleyball
//
//  Created by JASON HARRIS on 11/4/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameAndScoreDetails : NSObject

@property (nonatomic, assign) NSUInteger leftPlayerScore;
@property (nonatomic, assign) NSUInteger rightPlayerScore;
@property (nonatomic, assign) NSUInteger leftPlayerHits;
@property (nonatomic, assign) NSUInteger rightPlayerHits;
@property (nonatomic, assign) NSUInteger pointsPlayed;



+ (instancetype)sharedGameDataStore;

-(instancetype)init;

-(instancetype)initWithLeftScore:(NSUInteger)leftScore
                      rightScore:(NSUInteger)rightScore
                  leftPlayerHits:(NSUInteger)leftPlayerHits
                 rightPlayerHits:(NSUInteger)rightPlayerHits
                    pointsPlayed:(NSUInteger)pointsPlayed;

-(void)resetGame;

-(NSUInteger)leftPlayerHitTheBall;

-(NSUInteger)rightPlayerHitTheBall;

-(NSUInteger)leftPlayerScored;

-(NSUInteger)rightPlayerScored;





@end
