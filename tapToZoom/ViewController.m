//
//  ViewController.m
//  tapToZoom
//
//  Created by student on 15/01/2016.
//  Copyright © 2016 dungdang. All rights reserved.
//

#import "ViewController.h"
#define ZOOM_STEP 1.5
@interface ViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *photo;
@property (weak, nonatomic) UILabel * scaleLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.1;
    scrollView.maximumZoomScale = 10;
    scrollView.zoomScale = 1.0;
    scrollView.clipsToBounds = YES;
    
    UIImageView *photo = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    photo.image= [UIImage imageNamed:@"batman.jpg"];
    photo.contentMode = UIViewContentModeScaleAspectFill;
    photo.userInteractionEnabled = YES;
    photo.multipleTouchEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onTap:)];
    singleTap.numberOfTapsRequired= 1;
    singleTap.delegate = self;
    [photo addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired= 2;
    doubleTap.delegate= self;
    [photo addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [scrollView addSubview:photo];
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    self.photo = photo;
    
    UILabel* scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    scaleLabel.textAlignment= NSTextAlignmentRight;
    scaleLabel.text = [NSString stringWithFormat:@"%2.2f", scrollView.zoomScale];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithCustomView:scaleLabel];
    [self.navigationItem setRightBarButtonItem:barButton];
    self.scaleLabel = scaleLabel;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.photo;
}
- (void) onTap: (UITapGestureRecognizer*) tap {
    CGPoint tapPoint = [tap locationInView:self.photo];
    float newScale = self.scrollView.zoomScale *ZOOM_STEP;
    [self zoomRectForScale:newScale withCenter:tapPoint ];
}
- (void) onDoubleTap: (UITapGestureRecognizer*) tap {
    CGPoint tapPoint = [tap locationInView:self.photo];
    float newScale = self.scrollView.zoomScale /ZOOM_STEP;
    [self zoomRectForScale:newScale withCenter:tapPoint ];
}
- (void) zoomRectForScale: (float)scale
               withCenter: (CGPoint)center{
    CGRect zoomRect;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    zoomRect.size.height= scrollViewSize.height/scale;
    zoomRect.size.width= scrollViewSize.width/scale;
    zoomRect.origin.x = center.x-(zoomRect.size.width/2.0);
    zoomRect.origin.y = center.y-(zoomRect.size.width/2.0);
    [self.scrollView zoomToRect:zoomRect animated:YES];
    self.scaleLabel.text = [NSString stringWithFormat:@"%2.2f", self.scrollView.zoomScale];
    
    
}
@end
