//
//  PICircularProgressView.m
//  PICircularProgressView
//
//  Created by Dominik Alexander on 11.06.13.
//  Copyright (c) 2013 Dominik Alexander. All rights reserved.
//

#import "PICircularProgressView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define Rect(X, Y, W, H) CGRectMake((X), (Y), (W), (H))

@interface PICircularProgressView()


@end

@implementation PICircularProgressView

@synthesize touchview;
@synthesize textLabel;
@synthesize startButton;

+ (void)initialize
{
    if (self == [PICircularProgressView class])
    {
        id appearance = [self appearance];
        
        [appearance setShowText:YES];
        // 设置头部为圆形
        [appearance setRoundedHead:YES];
        // 显示进度条的外框
        [appearance setShowShadow:YES];
        [appearance setThicknessRatio:0.1f];
        
        
        
        [appearance setInnerBackgroundColor:nil];
        [appearance setInnerBackgroundColor:[UIColor redColor]];
        
        // 圆的背景图颜色
//        [appearance setOuterBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2]];
//        [appearance setOuterBackgroundColor:[UIColor lightGrayColor]];
        
        [appearance setTextColor:[UIColor blackColor]];
        [appearance setFont:[UIFont systemFontOfSize:10]];
        
        //  进度条的颜色
        [appearance setProgressFillColor:nil];
        
        // 进度条开头的颜色
        [appearance setProgressTopGradientColor:[UIColor colorWithRed:74/255.0 green:200/255.0 blue:180/255.0 alpha:0.8]];
        
        // 进度条结尾颜色
        [appearance setProgressBottomGradientColor:[UIColor colorWithRed:114.0/255.0 green:174.0/255.0 blue:235.0/255.0 alpha:1.0]];
        
        // 整个正方形的背景色
        [appearance setBackgroundColor:[UIColor clearColor]];
        
        
    }
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    
//    if (touchview == nil)
//    {
//        
//        touchview = [[UIImageView alloc] init];
//        self.touchview.userInteractionEnabled = YES;
//        self.touchview.backgroundColor = [UIColor clearColor];
//
//        
//        textLabel = [[UILabel alloc] init];
//        self.healthLabel = [[UILabel alloc]init];//健康指数
//        self.triangleImageView = [[UIImageView alloc]init];//下三角标志
//        self.triangleLabel = [[UILabel alloc]init];//下降指标
//        self.pointLabel = [[UILabel alloc]init];
//        
//        startButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [startButton addTarget:self
//                        action:@selector(startButtonPress)
//              forControlEvents:UIControlEventTouchUpInside];
//        
//        [startButton setBackgroundImage:[UIImage imageNamed:@"button－nor"] forState:UIControlStateNormal];
//        [startButton setBackgroundImage:[UIImage imageNamed:@"button－down"] forState:UIControlStateSelected];
//        [self addSubview:self.touchview];
//    }
//    
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    
    CGFloat progressAngle = _progress * 360.0 - 90;
    CGFloat radius = MIN(rect.size.width, rect.size.height) / 2.0f;
    
    CGRect square;
    if (rect.size.width > rect.size.height)
    {
        square = CGRectMake((rect.size.width - rect.size.height) / 2.0, 0.0, rect.size.height, rect.size.height);
    }
    else
    {
        square = CGRectMake(0.0, (rect.size.height - rect.size.width) / 2.0, rect.size.width, rect.size.width);
    }
    
    
    CGFloat circleWidth = radius * _thicknessRatio;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (_innerBackgroundColor)
    {
        // Fill innerCircle with innerBackgroundColor
        UIBezierPath *innerCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius - circleWidth
                                                               startAngle:2*M_PI
                                                                 endAngle:0.0
                                                                clockwise:YES];
        
        [_innerBackgroundColor setFill];
        
        [innerCircle fill];
        
    }
    
    if (_outerBackgroundColor)
    {
        // Fill outerCircle with outerBackgroundColor
        UIBezierPath *outerCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius
                                                               startAngle:0.0
                                                                 endAngle:2*M_PI
                                                                clockwise:NO];
        [outerCircle addArcWithCenter:center
                               radius:radius - circleWidth
                           startAngle:2*M_PI
                             endAngle:0.0
                            clockwise:YES];
        
        [_outerBackgroundColor setFill];
        
        [outerCircle fill];
    }
    
    if (_showShadow)
    {
        // Draw shadows
        CGFloat locations[5] = { 0.0f, 0.33f, 0.66f, 1.0f };
//        NSArray *gradientColors = @[
//                                    (id)[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor],
//                                    (id)[[UIColor colorWithWhite:0.9 alpha:0.0] CGColor],
//                                    (id)[[UIColor colorWithWhite:0.9 alpha:0.0] CGColor],
//                                    (id)[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor],
//                                    ];

        NSArray *gradientColors = @[
                                    (id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor],
                                    (id)[[UIColor colorWithWhite:0.0 alpha:0.7] CGColor],
                                    (id)[[UIColor colorWithWhite:0.0 alpha:0.7] CGColor],
                                    (id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor],
                                    ];
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)gradientColors, locations);
        CGContextDrawRadialGradient(context, gradient, center, radius - circleWidth, center, radius, 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(rgb);
    }
    
    if (_showText && _textColor)
    {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        NSString *progressString ;
        if ([currentLanguage isEqualToString:@"en"])
            progressString = [NSString stringWithFormat:@"%d bpm", _heart];
        else
            progressString = [NSString stringWithFormat:@"%d次/分", _heart];
        
        
        CGFloat fontSize = radius;
        
        //        UIFont *font = [_font fontWithSize:fontSize];
        UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
        
        
        CGFloat diagonal = 2 * (radius - circleWidth);
        CGFloat edge = diagonal / sqrtf(2);
        
        CGFloat actualFontSize;
        CGSize maximumSize = CGSizeMake(edge, edge);
        CGSize expectedSize = [progressString sizeWithFont:font
                                               minFontSize:5.0
                                            actualFontSize:&actualFontSize
                                                  forWidth:maximumSize.width
                                             lineBreakMode:NSLineBreakByWordWrapping];
        
        if (actualFontSize < fontSize)
        {
            font = [font fontWithSize:actualFontSize];
            expectedSize = [progressString sizeWithFont:font
                                            minFontSize:5.0
                                         actualFontSize:&actualFontSize
                                               forWidth:maximumSize.width
                                          lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        CGPoint origin = CGPointMake(center.x - expectedSize.width / 2.0, center.y - expectedSize.height / 2.0);
        
        [_textColor setFill];
        
        [progressString drawAtPoint:origin forWidth:expectedSize.width withFont:font lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center
                                                    radius:radius
                                                startAngle:DEGREES_TO_RADIANS(-90)
                                                  endAngle:DEGREES_TO_RADIANS(progressAngle)
                                                 clockwise:YES]];
    
    if (_roundedHead)
    {
        CGPoint point;
        point.x = (cos(DEGREES_TO_RADIANS(progressAngle)) * (radius - circleWidth/2)) + center.x;
        point.y = (sin(DEGREES_TO_RADIANS(progressAngle)) * (radius - circleWidth/2)) + center.y;
        
        [path addArcWithCenter:point
                        radius:circleWidth/2
                    startAngle:DEGREES_TO_RADIANS(progressAngle)
                      endAngle:DEGREES_TO_RADIANS(270.0 + progressAngle - 90.0)
                     clockwise:YES];
        NSLog(@"ldq1 %f",point.x);

    }
    
    [path addArcWithCenter:center
                    radius:radius-circleWidth
                startAngle:DEGREES_TO_RADIANS(progressAngle)
                  endAngle:DEGREES_TO_RADIANS(-90)
                 clockwise:NO];
    
    if (_roundedHead)
    {
//        CGPoint point;
//        point.x = (cos(DEGREES_TO_RADIANS(-90)) * (radius - circleWidth/2)) + center.x;
//        point.y = (sin(DEGREES_TO_RADIANS(-90)) * (radius - circleWidth/2)) + center.y;
//        
//        [path addArcWithCenter:point
//                        radius:circleWidth/2
//                    startAngle:DEGREES_TO_RADIANS(90)
//                      endAngle:DEGREES_TO_RADIANS(-90)
//                     clockwise:NO];
//        NSLog(@"ldq %f",point.x);
    }
    
    [path closePath];
    
    if (_progressFillColor)
    {
        [_progressFillColor setFill];
        [path fill];
    }
    else if (_progressTopGradientColor && _progressBottomGradientColor)
    {
        [path addClip];
        
        NSArray *backgroundColors = @[
                                      (id)[_progressTopGradientColor CGColor],
                                      (id)[_progressBottomGradientColor CGColor],
                                      ];
        CGFloat backgroudColorLocations[2] = { 0.0f, 1.0f };
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef backgroundGradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)(backgroundColors), backgroudColorLocations);
        CGContextDrawLinearGradient(context,
                                    backgroundGradient,
                                    CGPointMake(0.0f, square.origin.y),
                                    CGPointMake(0.0f, square.size.height),
                                    0);
        CGGradientRelease(backgroundGradient);
        CGColorSpaceRelease(rgb);
    }
    
    CGContextRestoreGState(context);
    
    //    self.touchview.frame = CGRectMake(0, 0, (radius - circleWidth)*3/2, (radius - circleWidth)*3/2);
    
    self.touchview.frame = CGRectMake(0, 0, (radius - circleWidth)*2, (radius - circleWidth)*2);
    
    self.textLabel.frame = self.touchview.frame;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:70.0];
    self.startButton.frame = self.touchview.frame;
    
    
    //笑脸
    CGPoint point;
    point.x = (cos(DEGREES_TO_RADIANS(progressAngle)) * (radius - circleWidth/2)) + center.x;
    point.y = (sin(DEGREES_TO_RADIANS(progressAngle)) * (radius - circleWidth/2)) + center.y;
    NSLog(@"qqqq  %f",self.progress);
       UIImageView * smilingImageView = [[UIImageView alloc]initWithFrame:Rect(point.x - 15, point.y - 15, 30, 30)];
//    smilingImageView.image = [UIImage imageNamed:@"---笑脸.png"];
    
    [self addSubview:smilingImageView];

    //健康指数
    self.healthLabel.frame = CGRectMake(0, 10, (radius - circleWidth)*2, 30);
    self.healthLabel.text = @"健康指数";
    self.healthLabel.textAlignment = NSTextAlignmentCenter;
    self.healthLabel.font = [UIFont systemFontOfSize:15.0];
    self.healthLabel.textColor = [UIColor whiteColor];
    
    self.pointLabel.frame = CGRectMake(CGRectGetMidX(self.touchview.frame) + 40, CGRectGetMidY(self.touchview.frame) + 10, 20, 20);
    self.pointLabel.text = @"分";
    self.pointLabel.textColor = [UIColor whiteColor];
    self.pointLabel.font = [UIFont systemFontOfSize:10.0];
    
    self.triangleImageView.frame = CGRectMake(45, CGRectGetHeight(self.frame) - 50, 20, 20);
    self.triangleImageView.image = [UIImage imageNamed:@"iconfont-shangsheng.png"];
    self.triangleLabel.frame = CGRectMake(CGRectGetMaxX(self.triangleImageView.frame) , CGRectGetHeight(self.frame) - 50, 30, 20);
    self.triangleLabel.textColor =[UIColor whiteColor];
    self.triangleLabel.text = @"7分";
    
    
    
    
    
    //    self.textLabel.backgroundColor = [UIColor redColor];
    self.touchview.center = center;
    
    //    [self.touchview setImage:[UIImage imageNamed:@"girl"]];
    
    self.touchview.layer.masksToBounds = YES;
    self.touchview.layer.cornerRadius = self.touchview.frame.size.width/2;
    
    self.touchview.layer.shadowRadius = 2;
    self.touchview.layer.shadowOpacity = 0.6;
    self.touchview.layer.shadowOffset = CGSizeMake(0, 1);
    
    
}

#pragma mark - Setter

- (void)setProgress:(double)progress
{
    _progress = MIN(1.0, MAX(0.0, progress));
    
    [self setNeedsDisplay];
}

#pragma mark - UIAppearance


- (void)setShowText:(NSInteger)showText
{
    _showText = showText;
    
    [self setNeedsDisplay];
}

- (void)setRoundedHead:(NSInteger)roundedHead
{
    _roundedHead = roundedHead;
    
    [self setNeedsDisplay];
}

- (void)setShowShadow:(NSInteger)showShadow
{
    _showShadow = showShadow;
    
    [self setNeedsDisplay];
}

- (void)setThicknessRatio:(CGFloat)thickness
{
    
    //    NSLog(@"---------thickness %f",thickness);
    _thicknessRatio = MIN(MAX(0.0f, thickness), 1.0f);
    
    //    NSLog(@"====thicknessRatio is %f",_thicknessRatio);
    
    [self setNeedsDisplay];
}

- (void)setInnerBackgroundColor:(UIColor *)innerBackgroundColor
{
    _innerBackgroundColor = innerBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setOuterBackgroundColor:(UIColor *)outerBackgroundColor
{
    _outerBackgroundColor = outerBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressFillColor:(UIColor *)progressFillColor
{
    _progressFillColor = progressFillColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressTopGradientColor:(UIColor *)progressTopGradientColor
{
    _progressTopGradientColor = progressTopGradientColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressBottomGradientColor:(UIColor *)progressBottomGradientColor
{
    _progressBottomGradientColor = progressBottomGradientColor;
    
    [self setNeedsDisplay];
}

#pragma mark - touch

-(void)startButtonPress
{
    
    if ([self.delegate respondsToSelector:@selector(startTouch)])
    {
        [self.delegate startTouch];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(startTouch)])
    {
        [self.delegate startTouch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}



@end
