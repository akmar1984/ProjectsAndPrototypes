//
//  LevelSelectViewController.m
//  gierka
//
//  Created by Marek Tomaszewski on 03/03/2015.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "LevelSelectViewController.h"
#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "GameScene.h"
#import "SKTAudio.h"

@interface LevelSelectViewController () <UIScrollViewDelegate>
//@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGSize imageSize;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (nonatomic) UIButton *curButton;
@property (nonatomic, weak) MainMenuViewController *mainMenuViewController;
@end

@implementation LevelSelectViewController
static const CGFloat kMargin = 40;


-(IBAction)backButton:(id)sender{
    

    self.mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    self.mainMenuViewController.musicOn = YES;
    [self.navigationController pushViewController:self.mainMenuViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat initialMargin = CGRectGetMidX(self.view.bounds);
    self.buttons = [NSMutableArray array];
    self.imageSize = [UIImage imageNamed:@"screen01.png"].size;
    self.scrollView.delegate = self;
       
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(141, 200, initialMargin*2 + ((kMargin + self.imageSize.width) * 5), self.imageSize.height)];
   
//    
//    UIButton *curButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    curButton.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
//    [curButton setImage:[UIImage imageNamed:@"screen01"] forState:UIControlStateNormal];
//    
//    [self.contentView addSubview:curButton];
//    
   
    for (int i = 1; i <= 6; ++i) {
        
    NSString *imageName = [NSString stringWithFormat:@"screen0%d", i];
    UIImage *image = [UIImage imageNamed:imageName];
    self.curButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
       [self.curButton setImage:image forState:UIControlStateNormal];
        CGFloat initialMargin = 10;
        CGFloat marginPerImage = kMargin + self.imageSize.width;
       // self.curButton.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
        self.curButton.frame = CGRectMake(initialMargin + (marginPerImage * (i - 1)), 0, self.imageSize.width, self.imageSize.height);

        
    [self.curButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.curButton.tag = i;
    self.curButton.adjustsImageWhenHighlighted = YES;
        [self.contentView addSubview:self.curButton];
    }
    
    self.scrollView.contentSize = CGSizeMake(initialMargin*2 + ((kMargin + self.imageSize.width) * 4.5), self.imageSize.height);
   // self.scrollView.contentSize = CGSizeMake(initialMargin*2 + ((kMargin + self.imageSize.width) * 5), self.imageSize.height);
    
    [self.scrollView addSubview:self.contentView];
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [self.scrollView addGestureRecognizer:tapRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    
    NSLog(@"%ld", (long)view.tag);
    
    
    //    GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
//    gameViewController.levelNum = view.tag;
//    [self.navigationController pushViewController:gameViewController animated:NO];
//
}
- (void)buttonTapped:(UIButton *)button{

//    CGPoint newCenter = [self.contentView convertPoint:button.center toView:self.scrollView];
//    [button removeFromSuperview];
//    button.center = newCenter;
//    [self.scrollView addSubview:button];
//
   
    GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    gameViewController.levelNum = button.tag;
    [[SKTAudio sharedInstance]pauseBackgroundMusic];

    [self.navigationController pushViewController:gameViewController animated:NO];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat marginPerImage = kMargin + self.imageSize.width;
    
    CGFloat overshoot = fmodf(targetContentOffset->x, marginPerImage);
    if (overshoot < marginPerImage / 2) {
        targetContentOffset->x -= overshoot ;
    } else {
        targetContentOffset->x += marginPerImage - overshoot;
    }
    
}


#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self updatePosition];
//}
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
