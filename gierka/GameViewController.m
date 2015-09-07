//
//  GameViewController.m
//  gierka
//
//  Created by Marek Tomaszewski on 27/10/2014.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameScene2.h"
#import "GameScene3.h"
#import "GameScene4.h"
#import "WardrobeScene.h"
#import "MenuScene.h"
#import "GameScene5.h"
#import "MainMenuViewController.h"
#import "SKTAudio.h"
#import "TheEndScene.h"

@interface GameViewController()



@end
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

-(void)fadeOutTheMusic
{
    if (self.backgroundMusicPlayer.volume > 0.1) {
        self.backgroundMusicPlayer.volume = self.backgroundMusicPlayer.volume - 0.1;
        [self performSelector:@selector(fadeOutTheMusic) withObject:nil afterDelay:0.1];
        if (self.backgroundMusicPlayer == 0) {
                   }
    } else {
        // Stop and get the sound ready for playing again
        [self.backgroundMusicPlayer stop];
        self.backgroundMusicPlayer.currentTime = 0;
        [self.backgroundMusicPlayer prepareToPlay];
        self.backgroundMusicPlayer.volume = 1.0;
    }
}

-(IBAction)exitButton:(UIButton *)sender{
    
    UIAlertController *alertController;
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *exitToMainMenu = [UIAlertAction actionWithTitle:NSLocalizedString(@"ExitToMainMenu",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        if (action.enabled) {
           
           // [self fadeOutTheMusic];
           
            [[SKTAudio sharedInstance]pauseSoundEffectInaLoop];
            [self loadMainMenu];
            self.exitButton.hidden = YES;
            self.exitButton.enabled = NO;
            

        }
    }];
    //     UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:nil];
    //     UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    //
    //    if (self.mainMenuActive == NO) {
    
    alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Paused",nil) message:NSLocalizedString(@"Pick one of the options", nil)  preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:exitToMainMenu];
    [alertController addAction:cancelButton];
    
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
    }
    //TO DO CHECK WHY THERE IS NO FADE OUT ON THE EXIT BUTTON IN SCENE 2
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//SET THE MAIN MENIU WITH LOADING THE GAME VIEW CONTROLLER
-(void)loadMainMenu{
    
    MainMenuViewController *mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    //    self.exitButton.enabled = NO;
    //    self.exitButton.hidden = YES;
    
    [self.navigationController pushViewController:mainMenuViewController animated:YES];
    
    
    
    
    
}
- (void)playBackgroundMusic:(NSString *)filename
{
    
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    self.backgroundMusicPlayer.volume = 0.5;
    [self.backgroundMusicPlayer prepareToPlay];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Configure the view.
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene){
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        skView.ignoresSiblingOrder = YES;
        skView.showsPhysics = NO;
        //  SKScene *scene = [[GameScene alloc] initWithSize:CGSizeMake(1024, 768)];
        
        if (self.levelNum == 1) {
            GameScene *scene;
            scene = [GameScene
                     sceneWithSize:skView.bounds.size];
//                        TheEndScene *scene;
//                        scene = [TheEndScene
//                                 sceneWithSize:skView.bounds.size];

        //  [self playBackgroundMusic:@"BackgroundMusicScene1.mp3"];
          //  [self.backgroundMusicPlayer play];
            
        //    scene.backgroundMusicPlayer = self.backgroundMusicPlayer;
            scene.scaleMode = SKSceneScaleModeAspectFill;
            skView.showsPhysics = NO;
            [skView presentScene:scene];
        }else if (self.levelNum == 2){
            GameScene2 *scene = [GameScene2
                     sceneWithSize:skView.bounds.size];
            skView.showsPhysics = NO;
            scene.backgroundMusicPlayer = self.backgroundMusicPlayer;
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }else if (self.levelNum == 3){
           GameScene3 *scene = [GameScene3
                     sceneWithSize:skView.bounds.size];
            scene.backgroundMusicPlayer = self.backgroundMusicPlayer;
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }else if (self.levelNum ==4){
            WardrobeScene *scene = [WardrobeScene
                     unarchiveFromFile:@"wardrobeScene"];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            scene.backgroundMusicPlayer = self.backgroundMusicPlayer;
            [skView presentScene:scene];
        }else if (self.levelNum == 5){
           GameScene4 *scene = [GameScene4
                     sceneWithSize:skView.bounds.size];
            scene.backgroundMusicPlayer = self.backgroundMusicPlayer;
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }else if (self.levelNum == 6){
           GameScene5 *scene = [GameScene5
                     sceneWithSize:skView.bounds.size];
   //         scene.backgroundMusicPlayer = self.backgroundMusicPlayer;
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }

              //  [self.backgroundMusicPlayer play];

        
        //}
        // Create and configure the scene.
        //   WardrobeScene *scene =  [WardrobeScene unarchiveFromFile:@"wardrobeScene"];
        //    scene.scaleMode = SKSceneScaleModeAspectFill;
        //
        //    // Present the scene.
        //    [skView presentScene:scene];
        //    }}
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
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
