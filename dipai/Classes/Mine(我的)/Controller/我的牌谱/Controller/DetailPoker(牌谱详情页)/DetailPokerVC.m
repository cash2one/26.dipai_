//
//  DetailPokerVC.m
//  dipai
//
//  Created by 梁森 on 16/9/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DetailPokerVC.h"

#import "NavigationBarV.h"
#import "Masonry.h"

// 预览页面每个小的视图
#import "PreviewCellView.h"

#import "AFNetworking.h"

#import "UIImage+extend.h"
#import "SVProgressHUD.h"
@interface DetailPokerVC ()

// 预览牌谱
@property (nonatomic, strong) UIView         * pokerV;

@property (nonatomic, strong) NSMutableArray * lblArr;

@end

@implementation DetailPokerVC

- (NSMutableArray *)lblArr{
    
    if (_lblArr == nil) {
        _lblArr = [NSMutableArray array];
    }
    return _lblArr;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    NSLog(@"textArr:jj%@", self.textArr);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpUI];
}

- (void)setUpUI{
    
    NavigationBarV * topV = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:topV];
    topV.backgroundColor = [UIColor blackColor];
    
    [topV.popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [topV.rightBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    
    topV.leftStr = @"";
    topV.rightStr = @"完成";
    topV.titleStr = @"牌谱详情";
    
    
    
    CGRect rect;
    if (HEIGHT > 667) {
        rect = CGRectMake(-1, 63, WIDTH+1, HEIGHT-63);
    }else{
        rect = CGRectMake(0, 64, WIDTH, HEIGHT-64);
    }
    UIImageView * backV = [[UIImageView alloc] initWithFrame:rect];
    [self.view addSubview:backV];
    backV.userInteractionEnabled = YES;
    backV.image = [UIImage imageNamed:@"beijingtu"];
    
    UIScrollView * scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [backV addSubview:scrollV];
//    scrollV.backgroundColor = [UIColor redColor];
    
    if (self.text && self.text.length > 0) {    // 如果是自定义模式
        [self addDefineUIWithSC:scrollV];
    }else{
        
        [self addStandardUIWithSC:scrollV];
    }
    

}

- (void)addDefineUIWithSC:(UIScrollView *)scrollV{
    
    // 显示牌谱
    UIView * pokerV = [[UIView alloc] init];
    [scrollV addSubview:pokerV];
    pokerV.backgroundColor = RGBA(23, 23, 23, 1);
    pokerV.layer.masksToBounds = YES;
//    pokerV.layer.cornerRadius = 4;
    _pokerV = pokerV;
    
    // 牌谱内容
    UILabel * contentLbl = [[UILabel alloc] init];
    contentLbl.numberOfLines = 0;
    contentLbl.text = self.text;
    contentLbl.textColor = [UIColor whiteColor];
    contentLbl.font = Font12;
    CGFloat contentX = 30 * IPHONE6_W_SCALE;
    CGFloat contentY = 29 * IPHONE6_H_SCALE;
    CGFloat contentW = WIDTH - 90 * IPHONE6_W_SCALE;
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font12;
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    contentLbl.frame = (CGRect){{contentX, contentY}, rect.size};
    [pokerV addSubview:contentLbl];
    CGFloat pokerH = rect.size.height + 190 * 0.5 * IPHONE6_H_SCALE;
    pokerV.frame = CGRectMake(15 * IPHONE6_W_SCALE, 14 * IPHONE6_H_SCALE, WIDTH - 30 * IPHONE6_W_SCALE, pokerH);
    
    // 内部边框
    UIView * borderV = [[UIView alloc] init];
    [pokerV addSubview:borderV];
    
    [borderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pokerV.mas_left).offset(10 * IPHONE6_W_SCALE);
        make.right.equalTo(pokerV.mas_right).offset(-10 * IPHONE6_W_SCALE);
        make.top.equalTo(pokerV.mas_top).offset(13 * IPHONE6_H_SCALE);
        make.bottom.equalTo(pokerV.mas_bottom).offset(-46 * IPHONE6_H_SCALE);
    }];
    
    borderV.layer.borderWidth = 1;
    borderV.layer.borderColor = [UIColor colorWithRed:54 / 255.f green:54 / 255.f blue:54 / 255.f alpha:2].CGColor;
    //    pokerV.layer.borderColor = [UIColor redColor].CGColor;-
    
    // 制作人
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.font = Font11;
    nameLbl.textColor = RGBA(181, 181, 181, 1);
    
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:pokerMaker];
    
    NSDictionary * dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:User];
    NSString * username = dataDic[@"username"];
    
    if ([self.userName isKindOfClass:[NSNull class]] || self.userName == nil) {
        self.userName = username;
    }
    NSDictionary * wxDic = [[NSUserDefaults standardUserDefaults] objectForKey:WXUser];
    if (wxDic.count > 0) {
        self.userName = wxDic[@"username"];
    }
    
    nameLbl.text = [NSString stringWithFormat:@"%@%@", @"牌谱制作：",self.userName];
    [pokerV addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pokerV.mas_left).offset(14 * IPHONE6_W_SCALE);
        make.top.equalTo(borderV.mas_bottom).offset(16 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 110 * IPHONE6_W_SCALE));
        make.height.equalTo(@(13 * IPHONE6_H_SCALE));
    }];
    
    // 底牌logo
    UIImageView * logoV = [[UIImageView alloc] init];
    logoV.image = [UIImage imageNamed:@"logo"];
    [pokerV addSubview:logoV];
    [logoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pokerV.mas_right).offset(-14 * IPHONE6_W_SCALE);
        make.bottom.equalTo(pokerV.mas_bottom).offset(-18 * IPHONE6_H_SCALE);
        make.width.equalTo(@(52 * IPHONE6_W_SCALE));
        make.height.equalTo(@(17 * IPHONE6_W_SCALE));
    }];
    
    scrollV.contentSize = CGSizeMake(WIDTH, 64+pokerV.frame.size.height);
}

- (void)popAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 改变图片大小的方法
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    
    UIGraphicsBeginImageContext(CGSizeMake(floor(reSize.width), floor(reSize.height)));
    [image drawInRect:CGRectMake(0, 0, floor(reSize.width), floor(reSize.height))];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
// 截取部分图像
-(UIImage*)getSubImage:(CGRect)rect withImage:(UIImage *)image
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (void)completeAction{
    
    if (self.text.length > 0) {
        CGFloat h;
        UIGraphicsBeginImageContextWithOptions(_pokerV.bounds.size, NO, 0);
        [_pokerV.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        CGFloat scale = 750 / image.size.width;
        h = scale * image.size.height;
        UIImage *img = [self reSizeImage:image toSize:CGSizeMake(750, h)];
        
        UIImage * viewImage = [self getSubImage:CGRectMake(0, 0, 750, h -2) withImage:img];
        
        //    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        UIGraphicsEndImageContext();
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        /*
         myfile（图片数组），title(标题),content(内容)
         */
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"myfile"] = nil;
        dic[@"information"] = self.text;
        NSString * url = nil;
        if (![AddDefinePoker hasPrefix:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, AddDefinePoker];
        }else{
            url = AddDefinePoker;
        }
        [HttpTool GET:MemberCenter parameters:nil success:^(id responseObject) {
            NSString * state = responseObject[@"96"];
            if ([state isEqualToString:@"96"]) {    // 如果异地登录
                NSString * message = responseObject[@"content"];
                UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 确定按钮做两个操作：1.退出登录  2.回到根视图
                    NSLog(@"退出登录...");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [OutLoginTool outLoginAction];
                    
                }];
                [alertC addAction:action];
                [self.navigationController presentViewController:alertC animated:YES completion:nil];
            }else{
                [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    UIImage * image = viewImage;
                    //            UIImage * image1 = [image rotateImage];
                    NSData * data = UIImagePNGRepresentation(image);
                    NSString * name = [NSString stringWithFormat:@"myfile%d", 1];
                    NSString * fileName = [NSString stringWithFormat:@"image%d.png", 1];
                    NSString * mimeType = [NSString stringWithFormat:@"image/png"];
                    [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
                    [SVProgressHUD showWithStatus:@"正在保存..."];
                } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    NSLog(@"上传图片成功:%@", responseObject);
                    NSLog(@"---content---%@", responseObject[@"content"]);
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    [SVProgressHUD showErrorWithStatus:@"保存失败"];
                    
                    NSLog(@"上传图片失败：%@", error);
                }];
                
            }
        } failure:^(NSError *error) {
            
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
  
    if (self.textArr.count > 0) {
        CGFloat h;
        UIGraphicsBeginImageContextWithOptions(_pokerV.bounds.size, NO, 0);
        [_pokerV.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        CGFloat scale = 750 / image.size.width;
        h = scale * image.size.height;
        UIImage *viewImage = [self reSizeImage:image toSize:CGSizeMake(750, h-2)];
        //    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        UIGraphicsEndImageContext();
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        /*
         myfile（图片数组），title(标题),content(内容)
         */
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"myfile"] = nil;
        dic[@"information"] = [self.textArr objectAtIndex:0];
        dic[@"preflop"] = [self.textArr objectAtIndex:1];
        dic[@"flop"] = [self.textArr objectAtIndex:2];
        dic[@"turn"] = [self.textArr objectAtIndex:3];
        dic[@"river"] = [self.textArr objectAtIndex:4];
        NSString * url = nil;
        if (![AddDefinePoker hasPrefix:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@", DipaiBaseURL, AddDefinePoker];
        }else{
            url = AddDefinePoker;
        }
        [HttpTool GET:MemberCenter parameters:nil success:^(id responseObject) {
            NSString * state = responseObject[@"state"];
            if ([state isEqualToString:@"96"]) {    // 如果异地登录
                NSString * message = responseObject[@"content"];
                UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 确定按钮做两个操作：1.退出登录  2.回到根视图
                    NSLog(@"退出登录...");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [OutLoginTool outLoginAction];
                    
                }];
                [alertC addAction:action];
                [self.navigationController presentViewController:alertC animated:YES completion:nil];
            }else{
                [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    UIImage * image = viewImage;
                    UIImage * image1 = [image rotateImage];
                    NSData * data = UIImagePNGRepresentation(image1);
                    NSString * name = [NSString stringWithFormat:@"myfile%d", 1];
                    NSString * fileName = [NSString stringWithFormat:@"image%d.png", 1];
                    NSString * mimeType = [NSString stringWithFormat:@"image/png"];
                    [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
                    [SVProgressHUD showWithStatus:@"正在保存..."];
                } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    NSLog(@"上传图片成功:%@", responseObject);
                    NSLog(@"---content---%@", responseObject[@"content"]);
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    [SVProgressHUD showErrorWithStatus:@"保存失败"];
                    
                    NSLog(@"上传图片失败：%@", error);
                }];

            }

        } failure:^(NSError *error) {
            
        }];
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}
// 保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}


/*********************************标准编辑预览****************************/
- (void)addStandardUIWithSC:(UIScrollView *)scrollV{
    
    NSLog(@"标准模式");
    // 显示牌谱
    UIView * pokerV = [[UIView alloc] init];
    [scrollV addSubview:pokerV];
    pokerV.backgroundColor = RGBA(23, 23, 23, 1);
    pokerV.layer.masksToBounds = YES;
//    pokerV.layer.cornerRadius = 4;
    _pokerV = pokerV;
    
    // 牌谱内容
    for (int i = 0; i < 5; i ++) {
        
        PreviewCellView * contentV = [[PreviewCellView alloc] init];
        [pokerV addSubview:contentV];
        [self.lblArr addObject:contentV];
    }
    
    PreviewCellView * contentV1 = [self.lblArr objectAtIndex:0];
    PreviewCellView * contentV2 = [self.lblArr objectAtIndex:1];
    PreviewCellView * contentV3 = [self.lblArr objectAtIndex:2];
    PreviewCellView * contentV4 = [self.lblArr objectAtIndex:3];
    PreviewCellView * contentV5 = [self.lblArr objectAtIndex:4];
    NSString * text1 = [self.textArr objectAtIndex:0];
    NSString * text2 = [self.textArr objectAtIndex:1];
    NSString * text3 = [self.textArr objectAtIndex:2];
    NSString * text4 = [self.textArr objectAtIndex:3];
    NSString * text5 = [self.textArr objectAtIndex:4];
    
//    NSLog(@"%@   %@    %@   %@    %@", text1, text2, text3, text4, text5);
    
    if (text1.length > 0) {
        CGFloat contentX = 18 * IPHONE6_W_SCALE;
        CGFloat contentY = 21 * IPHONE6_H_SCALE;
        CGFloat contentW = WIDTH - 66 * IPHONE6_W_SCALE;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font12;
        CGRect rect = [text1 boundingRectWithSize:CGSizeMake(WIDTH - 72 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        contentV1.frame = CGRectMake(contentX, contentY, contentW, rect.size.height + 70 * IPHONE6_H_SCALE);
        contentV1.titleLbl.text = @"牌局基本信息";
        contentV1.contentStr = text1;
        contentV1.hidden = NO;
    }else{
        contentV1.frame = CGRectMake(18 * IPHONE6_W_SCALE, 8 * IPHONE6_H_SCALE, 1, 1);
        contentV1.hidden = YES;
    }
    
    if (text2.length > 0) {
        contentV2.titleLbl.text = @"Preflop";
        contentV2.contentStr = text2;
        CGFloat contentX = 18 * IPHONE6_W_SCALE;
        CGFloat contentY = CGRectGetMaxY(contentV1.frame) + 13 * IPHONE6_H_SCALE;
        CGFloat contentW = WIDTH - 66 * IPHONE6_W_SCALE;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font12;
        CGRect rect = [text2 boundingRectWithSize:CGSizeMake(WIDTH - 72 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        contentV2.frame = CGRectMake(contentX, contentY, contentW, rect.size.height + 70 * IPHONE6_H_SCALE);
        contentV2.hidden = NO;
    }else{
        CGFloat contentY = CGRectGetMaxY(contentV1.frame);
        contentV2.frame = CGRectMake(18 * IPHONE6_W_SCALE, contentY, 1, 1);
        contentV2.hidden = YES;
    }
    if (text3.length > 0) {
        contentV3.titleLbl.text = @"Flop";
        contentV3.contentStr = text3;
        CGFloat contentX = 18 * IPHONE6_W_SCALE;
        CGFloat contentY = CGRectGetMaxY(contentV2.frame) + 13 * IPHONE6_H_SCALE;
        CGFloat contentW = WIDTH - 66 * IPHONE6_W_SCALE;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font12;
        CGRect rect = [text3 boundingRectWithSize:CGSizeMake(WIDTH - 72 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        
        contentV3.frame = CGRectMake(contentX, contentY, contentW, rect.size.height + 70 * IPHONE6_H_SCALE);
        contentV3.hidden = NO;
    }else{
        CGFloat contentY = CGRectGetMaxY(contentV2.frame);
        contentV3.frame = CGRectMake(18 * IPHONE6_W_SCALE, contentY, 1, 1);
        contentV3.hidden = YES;
    }
    if (text4.length > 0) {
        contentV4.titleLbl.text = @"Turn";
        contentV4.contentStr = text4;
        CGFloat contentX = 18 * IPHONE6_W_SCALE;
        CGFloat contentY = CGRectGetMaxY(contentV3.frame) + 13 * IPHONE6_H_SCALE;
        CGFloat contentW = WIDTH - 66 * IPHONE6_W_SCALE;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font12;
        CGRect rect = [text4 boundingRectWithSize:CGSizeMake(WIDTH - 72 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        contentV4.frame = CGRectMake(contentX, contentY, contentW, rect.size.height + 70 * IPHONE6_H_SCALE);
        contentV4.hidden = NO;
    }else{
        CGFloat contentY = CGRectGetMaxY(contentV3.frame);
        contentV4.frame = CGRectMake(18 * IPHONE6_W_SCALE, contentY, 1, 1);
        contentV4.hidden = YES;
    }
    if (text5.length > 0) {
        contentV5.titleLbl.text = @"River";
        contentV5.contentStr = text5;
        CGFloat contentX = 18 * IPHONE6_W_SCALE;
        CGFloat contentY = CGRectGetMaxY(contentV4.frame) + 13 * IPHONE6_H_SCALE;
        CGFloat contentW = WIDTH - 66 * IPHONE6_W_SCALE;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = Font12;
        CGRect rect = [text5 boundingRectWithSize:CGSizeMake(WIDTH - 72 * IPHONE6_W_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        contentV5.frame = CGRectMake(contentX, contentY, contentW, rect.size.height + 70 * IPHONE6_H_SCALE);
        contentV5.hidden = NO;
    }else{
        CGFloat contentY = CGRectGetMaxY(contentV4.frame);
        contentV5.frame = CGRectMake(18 * IPHONE6_W_SCALE, contentY, 1, 1);
        contentV5.hidden = YES;
    }
    CGFloat pokerH = CGRectGetMaxY(contentV5.frame) + 108 * 0.5 * IPHONE6_H_SCALE;
    
    
    pokerV.frame = CGRectMake(15 * IPHONE6_W_SCALE, 14 * IPHONE6_H_SCALE, WIDTH - 30 * IPHONE6_W_SCALE, pokerH);
    
    
    
    // 内部边框
    UIView * borderV = [[UIView alloc] init];
    [pokerV addSubview:borderV];
    
    [borderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pokerV.mas_left).offset(10 * IPHONE6_W_SCALE);
        make.right.equalTo(pokerV.mas_right).offset(-10 * IPHONE6_W_SCALE);
        make.top.equalTo(pokerV.mas_top).offset(13 * IPHONE6_H_SCALE);
        make.bottom.equalTo(pokerV.mas_bottom).offset(-46 * IPHONE6_H_SCALE);
    }];
    
    borderV.layer.borderWidth = 1;
    borderV.layer.borderColor = [UIColor colorWithRed:54 / 255.f green:54 / 255.f blue:54 / 255.f alpha:2].CGColor;
    // 制作人
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.font = Font11;
    nameLbl.textColor = RGBA(181, 181, 181, 1);
    
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:pokerMaker];
    
    NSDictionary * dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:User];
    NSString * username = dataDic[@"username"];
    
    if ([self.userName isKindOfClass:[NSNull class]] || self.userName == nil) {
        self.userName = username;
    }
    
    NSDictionary * wxDic = [[NSUserDefaults standardUserDefaults] objectForKey:WXUser];
    if (wxDic.count > 0) {
        self.userName = wxDic[@"username"];
    }
    
    nameLbl.text = [NSString stringWithFormat:@"%@%@", @"牌谱制作：", self.userName];
    [pokerV addSubview:nameLbl];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pokerV.mas_left).offset(14 * IPHONE6_W_SCALE);
        make.top.equalTo(borderV.mas_bottom).offset(16 * IPHONE6_H_SCALE);
        make.width.equalTo(@(WIDTH - 110 * IPHONE6_W_SCALE));
        make.height.equalTo(@(13 * IPHONE6_H_SCALE));
    }];
    
    // 底牌logo
    UIImageView * logoV = [[UIImageView alloc] init];
    logoV.image = [UIImage imageNamed:@"logo"];
    [pokerV addSubview:logoV];
    [logoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pokerV.mas_right).offset(-14 * IPHONE6_W_SCALE);
        make.bottom.equalTo(pokerV.mas_bottom).offset(-18 * IPHONE6_H_SCALE);
        make.width.equalTo(@(52 * IPHONE6_W_SCALE));
        make.height.equalTo(@(17 * IPHONE6_W_SCALE));
    }];
    
    scrollV.contentSize = CGSizeMake(WIDTH, 64 +pokerV.frame.size.height);
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
