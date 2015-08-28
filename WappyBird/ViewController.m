//
//  ViewController.m
//  WappyBird
//
//  Created by Peng on 8/26/15.
//  Copyright © 2015 Peng. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "Score.h"
#import "Macros.h"

@interface ViewController ()

@property (strong,nonatomic)  SKView *gameView;
@property (strong,nonatomic)  UIView *getReadyView;

@property (strong,nonatomic)  UIView *gameOverView;
@property (strong,nonatomic)  UIImageView *medalImageView;
@property (strong,nonatomic)  UILabel *currentScore;
@property (strong,nonatomic)  UILabel *bestScore;


@end

@implementation ViewController
{
    Scene * scene;
    UIView * flash;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.gameView = [[SKView alloc] initWithFrame:self.view.bounds];
    
    self.getReadyView = [[UIView alloc] initWithFrame:CGRectMake(0, 188.0f, 320.0f, 192.0f)];
    
    UIImageView *getReadyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f, 0.0f, 260.0f, 45.0f)];
    getReadyImageView.image = [UIImage imageNamed:@"get_ready.png"];
    UIImageView *taptapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 62.0f, 240.0f, 110.0f)];
    taptapImageView.image = [UIImage imageNamed:@"taptap.png"];
    [self.getReadyView addSubview:getReadyImageView];
    [self.getReadyView addSubview:taptapImageView];
    [self.gameView addSubview:self.getReadyView];
    
    self.gameOverView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 188.0f, 320.0f, 220.0f)];
    UIImageView *gameOverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f, 0.0f, 260.0f, 45.0f)];
    gameOverImageView.image = [UIImage imageNamed:@"game_over.png"];
    UIImageView *medalPlateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(47.0f, 62.0f, 226.0f, 116.0f)];
    medalPlateImageView.image = [UIImage imageNamed:@"medal_plate.png"];
    UIImageView *medalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(73.0f, 104.0f, 44.0f, 44.0f)];
    medalImageView.image = [UIImage imageNamed:@"medal_bronze.png"];
    self.currentScore = [[UILabel alloc] initWithFrame:CGRectMake(199.0f, 94.0f, 50.0f, 21.0f)];
    self.currentScore.text = @"5";
    self.bestScore = [[UILabel alloc] initWithFrame:CGRectMake(199.0f, 135.0f, 50.0f, 21.0f)];
    self.bestScore.text = @"32";
    [self.gameOverView addSubview:gameOverImageView];
    [self.gameOverView addSubview:medalPlateImageView];
    [self.gameOverView addSubview:medalImageView];
    [self.gameOverView addSubview:self.currentScore];
    [self.gameOverView addSubview:self.bestScore];
    [self.gameView addSubview:self.gameOverView];
    
    [self.view addSubview:self.gameView];
    
    
    // Configure the view.
    //self.gameView.showsFPS = YES;
    //self.gameView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [Scene sceneWithSize:self.gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    
    // Present the scene
    self.gameOverView.alpha = 0;
    self.gameOverView.transform = CGAffineTransformMakeScale(.9, .9);
    [self.gameView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Bouncing scene delegate

- (void)eventStart
{
    [UIView animateWithDuration:.2 animations:^{
        self.gameOverView.alpha = 0;
        self.gameOverView.transform = CGAffineTransformMakeScale(.8, .8);
        flash.alpha = 0;
        self.getReadyView.alpha = 1;
    } completion:^(BOOL finished) {
        [flash removeFromSuperview];
        
    }];
}

- (void)eventPlay
{
    NSLog(@"eventPlay");
    [UIView animateWithDuration:.5 animations:^{
        self.getReadyView.alpha = 0;
    }];
}

- (void)eventWasted
{
    flash = [[UIView alloc] initWithFrame:self.view.frame];
    flash.backgroundColor = [UIColor whiteColor];
    flash.alpha = .9;
    [self.gameView insertSubview:flash belowSubview:self.getReadyView];
    
    [self shakeFrame];
    
    [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        // Display game over
        flash.alpha = .4;
        self.gameOverView.alpha = 1;
        self.gameOverView.transform = CGAffineTransformMakeScale(1, 1);
        
        // Set medal
        if(scene.score >= 40){
            self.medalImageView.image = [UIImage imageNamed:@"medal_platinum"];
        }else if (scene.score >= 30){
            self.medalImageView.image = [UIImage imageNamed:@"medal_gold"];
        }else if (scene.score >= 20){
            self.medalImageView.image = [UIImage imageNamed:@"medal_silver"];
        }else if (scene.score >= 10){
            self.medalImageView.image = [UIImage imageNamed:@"medal_bronze"];
        }else{
            self.medalImageView.image = nil;
        }
        
        // Set scores
        self.currentScore.text = F(@"%li",scene.score);
        self.bestScore.text = F(@"%li",(long)[Score bestScore]);
        
    } completion:^(BOOL finished) {
        flash.userInteractionEnabled = NO;
    }];
    
}

- (void) shakeFrame
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.view  center].x - 4.0f, [self.view  center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.view  center].x + 4.0f, [self.view  center].y)]];
    [[self.view layer] addAnimation:animation forKey:@"position"];
}

@end
