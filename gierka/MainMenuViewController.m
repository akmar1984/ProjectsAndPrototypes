//
//  MainMenuViewController.m
//  gierka
//
//  Created by Marek Tomaszewski on 03/03/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "LevelSelectViewController.h"
#import "SKTAudio.h"

@interface MainMenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *levelSelectButton;

@end

@implementation MainMenuViewController

/*
-(void)checkWhatDevice{
if(IS_IPAD)
{
    NSLog(@"IS_IPAD");
}
if(IS_IPHONE)
{
    NSLog(@"IS_IPHONE");
}
if(IS_RETINA)
{
    NSLog(@"IS_RETINA");
}
if(IS_IPHONE_4_OR_LESS)
{
    NSLog(@"IS_IPHONE_4_OR_LESS");
}
if(IS_IPHONE_5)
{
    NSLog(@"IS_IPHONE_5");
}
if(IS_IPHONE_6)
{
    NSLog(@"IS_IPHONE_6");
}
if(IS_IPHONE_6P)
{
    NSLog(@"IS_IPHONE_6P");
}

NSLog(@"SCREEN_WIDTH: %f", SCREEN_WIDTH);
NSLog(@"SCREEN_HEIGHT: %f", SCREEN_HEIGHT);
NSLog(@"SCREEN_MAX_LENGTH: %f", SCREEN_MAX_LENGTH);
NSLog(@"SCREEN_MIN_LENGTH: %f", SCREEN_MIN_LENGTH);
};
*/
-(IBAction)hitPlay:(id)sender{
    GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    gameViewController.levelNum = 1;
    //  gameViewController.exitButton.enabled = YES;
    //  gameViewController.exitButton.hidden = YES;
   
    [[SKTAudio sharedInstance]pauseBackgroundMusic];
//    [[SKTAudio sharedInstance]playBackgroundMusic:@"BackgroundMusicScene1.mp3"];
    [self.navigationController pushViewController:gameViewController animated:YES];
    
}

-(IBAction)levelSelectButton:(id)sender{
    LevelSelectViewController *levelSelectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LevelSelectViewController"];
    
    [self.navigationController pushViewController:levelSelectViewController animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self checkWhatDevice];
    // Do any additional setup after loading the view.
    if (!self.musicOn){
        [[SKTAudio sharedInstance]pauseSoundEffect];
        [[SKTAudio sharedInstance]pauseBackgroundMusic];
        
        [[SKTAudio sharedInstance]playBackgroundMusic:@"LittleBellLMenuMusic.mp3"];
    
        //turn this on and set alpha to 0 in setupAnimations!
        [self setupAnimations];
        
    }
}
-(void)setupAnimations{
    self.titleLabel.alpha = 0;
    self.playButton.alpha = 0;
    self.playButton.center = CGPointMake(1024, 370);
    self.levelSelectButton.alpha = 0;
    self.levelSelectButton.center = CGPointMake(713, 768);
    [UIView animateWithDuration:4 animations:^{
        self.titleLabel.alpha = 1;
        
    }];
    
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.playButton.alpha = 1;
        self.playButton.center = CGPointMake(713, 370);
        self.levelSelectButton.alpha = 1;
        self.levelSelectButton.center = CGPointMake(713, 538);
        
    } completion:nil];
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

@end
