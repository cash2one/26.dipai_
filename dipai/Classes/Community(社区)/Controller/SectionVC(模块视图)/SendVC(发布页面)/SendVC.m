//
//  SendVC.m
//  dipai
//
//  Created by 梁森 on 16/6/22.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "SendVC.h"
#import "Masonry.h"
#import "LNPhotoLibaryController.h"
#import "X_SelectPicView.h"
#import "LNPhotoAsset.h"

// 自定义的textField
#import "LSTextField.h"

#import "LSTextView.h"
// 自定义的相册视图
#import "LSPicturesView.h"
// 登录页面
#import "LoginViewController.h"
#import "LSAlertView.h"

#import "AFNetworking.h"

#import "SVProgressHUD.h"

#import "SectionModel.h"

#import "DataTool.h"

#import "UIImage+extend.h"

// 牌谱页面
#import "MyPokersVC.h"

// 相册选择器
#import "ImgPickerViewController.h"
@interface SendVC ()<UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LSPicturesViewDelegate,X_SelectPicViewDelegate, LSAlertViewDeleagte>

{
    NSString * _previousTextFieldContent;
    UITextRange * _previousSelection;
    NSMutableArray *_selectPictures;                    //保存选中的图片
    LNPhotoLibaryController *_photoLibaryController;    //保持相册控制器的指针，方便传值
}
/**
 *  picture编辑view
 */
@property (nonatomic, strong) X_SelectPicView *pictureView;
/**
 *  发送按钮上的文字
 */
@property (nonatomic, strong) UILabel * sendLbl;
/**
 *  发送按钮
 */
@property (nonatomic, strong) UIButton * sendBtn;

/**
 *  标题
 */
@property (nonatomic, strong) LSTextField * field;

@property (nonatomic, strong) LSTextView * textView;

/**
 *  选择图片的视图
 */
@property (nonatomic, strong) UIView * selectPicView;
/**
 *  用来装图片的数组
 */
@property (nonatomic, strong) NSMutableArray * imagesArr;

/**
 *  相册视图
 */
@property (nonatomic, strong) LSPicturesView * pictures;
/**
 *  选择图片的按钮
 */
@property (nonatomic, strong) UIButton * picBtn;
/***************AlertView**********************/
@property (nonatomic, strong) UIView * alertBackView;

@property (nonatomic, strong) LSAlertView * alertView;

@property (nonatomic, strong) UIImagePickerController * imagePicker;

// 选择图片的张数
@property (nonatomic, strong) NSArray *Originals;

@property (nonatomic, strong) ImgPickerViewController* vc;

@end

@implementation SendVC

- (NSMutableArray *)imagesArr{
    if (_imagesArr == nil) {
        _imagesArr = [NSMutableArray array];
        
    }
    return _imagesArr;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    _selectPictures = [@[] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePickFinished:) name:IMAGE_PICKER object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_baise"] forBarMetrics:UIBarMetricsDefault];
    // 设置导航条上的左右侧按钮
    [self setUpLeftAndRightItem];
    
    // 添加标题
    [self addTextField];
    
    // 添加发布内容的textView
    [self addTextView];
    
    // 添加选择图片的视图
    [self addSelectPicView];
    
    // 设置图片视图
    [self setUpPicturesView];
    
    // 对UITextField添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    // 对UITextView添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged) name:UITextViewTextDidChangeNotification object:nil];
    // 对键盘添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)_initPicSelectView:(NSMutableArray *)info{
    if (!_pictureView) {
        _pictureView = [X_SelectPicView shareSelectPicView];
        _pictureView.delegate = self;
        __block typeof(self) weakSelf = self;
        _pictureView.Commplete = ^{ //跳转到相册
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_photoLibaryController];
            [weakSelf presentViewController:navigation animated:YES completion:^{
                
            }];
        };
    
        [self.view addSubview:_pictureView];
    }
    
    for (LNPhotoAsset *photoAsset in info) {
        if (![_selectPictures containsObject:photoAsset]) {
            [_selectPictures addObject:photoAsset];
        }
        
    }
    
    _pictureView.dataSource = _selectPictures;
    [self.imagesArr removeAllObjects];
    for (LNPhotoAsset * asset in _selectPictures) {
        UIImage * image = asset.thumbImage;
        [self.imagesArr addObject:image];
    }
    
}


- (void)setUpLeftAndRightItem
{
    // 取消按钮
    UILabel * cancel = [[UILabel alloc] init];
    cancel.font = Font15;
    cancel.text = @"取消";
    [self.navigationController.navigationBar addSubview:cancel];
    cancel.frame = CGRectMake(15, 0, 100, 44);
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationController.navigationBar addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(0, 0, 100, 44);
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    // 发送按钮
    UILabel * sendLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30*IPHONE6_W_SCALE, 44)];
    sendLbl.font = Font15;
    sendLbl.text = @"发布";
    sendLbl.textColor = Color178;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendLbl];
    _sendLbl = sendLbl;
    
    
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100, 0, 100, 44)];
    sendBtn.userInteractionEnabled = YES;
    sendBtn.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar  addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.userInteractionEnabled = NO;
    _sendBtn = sendBtn;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * IPHONE6_W_SCALE, 44)];
//        titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"发布新帖";
    self.navigationItem.titleView = titleLabel;
    
}

- (void)imagePickFinished:(NSNotification *)notification{
    
//    NSLog(@"图片选择王城...");
    
    [_field resignFirstResponder];
    [_textView resignFirstResponder];
    
    NSMutableArray *info = notification.object;
//    NSLog(@"%@", info);
    [self _initPicSelectView:info];
    

}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 发送事件
- (void)sendAction{

    
    // 得判断是否登录
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * cookieName = [defaults objectForKey:Cookie];
    NSDictionary * wxData = [defaults objectForKey:WXUser]; // face/userid/username
    
    NSLog(@"cookieName:%@", cookieName);
    
    if (cookieName || wxData) {
        NSLog(@"已经登录。。。进行发表");
        // 有图片发送图片
        if (self.imagesArr.count) {
            [self sendPictures];
        } else
        {
            [self sendText];
        }
        // 显示发表成功
//        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
    }else{
        [self addAlertView];
    }
}
#pragma mark --- 添加登录的alertView
- (void)addAlertView{
    LSAlertView * alertView = [[LSAlertView alloc] init];
    alertView.delegate = self;
    CGFloat x = Margin105 * IPHONE6_W_SCALE;
    CGFloat y = Margin574 * IPHONE6_H_SCALE;
    CGFloat w = Margin540 * IPHONE6_W_SCALE;
    CGFloat h = Margin208 * IPHONE6_H_SCALE;
    alertView.frame = CGRectMake(x, y, w, h);
    UIView * alertBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    alertBackView.backgroundColor = ColorBlack30;
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到灰色的背景图
    [window addSubview:alertBackView];
    [window addSubview:alertView];
    _alertBackView = alertBackView;
    _alertView = alertView;
}

#pragma mark --- LSAlertViewDeleagte
/**
 *  取消按钮的点击事件
 
 */
- (void)lsAlertView:(LSAlertView *)alertView cancel:(NSString * )cancel {
    [self removeAlerView];
}
- (void)removeAlerView
{
    // 移除提示框的背景图
    [_alertBackView removeFromSuperview];
    // 移除提示框
    [_alertView removeFromSuperview];
}
/**
 *  确定按钮的点击事件
 
 */
// 登录按钮
- (void)lsAlertView:(LSAlertView *)alertView sure:(NSString *)sure
{
    // 移除提示框
    [self removeAlerView];
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}
#pragma mark --- 截掉字符串前面的空格的方法
- (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet {
    NSString *returnVal = @"";
    if (val) {
        returnVal = [val stringByTrimmingCharactersInSet:characterSet];
    }
    return returnVal;
}

// 发送图片
- (void)sendPictures
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    /*
     myfile（图片数组），title(标题),content(内容)
     */
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"myfile"] = nil;
    dic[@"title"] = _field.text;
    NSString * content = [self trim:_textView.text trimCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    
    dic[@"content"] = content;
    SectionModel * sectionModel = self.sectionModel;
    NSLog(@"%@", sectionModel.iD);
    
//    NSString * url = @"http://dpapp.replays.net/app/add/forum/";
    NSString * url = formURL;
    url = [url stringByAppendingString:sectionModel.iD];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /**
         *  FileData:要上传文件的二进制数据
         name:上传参数名称
         fileName:上传到服务器的文件名称
         mimeType:文件类型
         */
        
        for (int i = 0; i < self.imagesArr.count; i ++) {
            UIImage * image = self.imagesArr[i];
//            NSData * data = UIImageJPEGRepresentation(image, 0.3);
            UIImage * image1 = [image rotateImage];
            NSData * data = UIImagePNGRepresentation(image1);
            NSString * name = [NSString stringWithFormat:@"myfile%d", i];
            NSString * fileName = [NSString stringWithFormat:@"image%d.jpeg", i];
            NSString * mimeType = [NSString stringWithFormat:@"image/png"];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
        [SVProgressHUD showWithStatus:@"发布中..."];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self dismiss];
        NSLog(@"上传图片成功:%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        
        NSLog(@"上传图片失败：%@", error);
    }];
    
    
    /*
     [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
     [request setHTTPBody:body];
     
     NSHTTPURLResponse *urlResponese = nil;
     NSError *error = [[NSError alloc]init];
     NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
     
     NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
     */
    
    
}
// 发送文字
- (void)sendText
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"myfile"] = nil;
    dic[@"title"] = _field.text;
    NSString * content = [self trim:_textView.text trimCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSLog(@"%@", content);
    
    dic[@"content"] = content;
    
    SectionModel * sectionModel = self.sectionModel;
    NSString * url = [SendPostsURL stringByAppendingString:sectionModel.iD];
    [DataTool postWithStr:url parameters:dic success:^(id responseObject) {
    
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self dismiss];
    } failure:^(NSError * error) {
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        NSLog(@"发布文字出错：%@", error);
    }];
}

#pragma mark --- 添加标题
- (void)addTextField{
    LSTextField * field = [[LSTextField alloc] init];
    field.delegate = self;
    field.frame = CGRectMake(0, 0, WIDTH, 43*IPHONE6_H_SCALE);
    field.myPlaceholder = @"标题(最多30个字符)";
    field.font = Font13;
    field.placeHolderX = 18 * IPHONE6_W_SCALE;
    field.placeHolderY = 12 * IPHONE6_H_SCALE;
    field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    field.leftViewMode = UITextFieldViewModeAlways;
//    field.leftViewX = 13;
    [self.view addSubview:field];
    
    [field becomeFirstResponder];
    
    _field = field;
    
    
    
}

#pragma mark --- 对TextField进行监听
- (void)textFieldChanged{
    
    if (_field.text.length ) {
        _field.hidePlaceHolder = YES;
        if (_field.text.length > 30) {   // 标题最多30个字符
            [_field setText:_previousTextFieldContent];
            _field.selectedTextRange = _previousSelection;
        }
        
    }else
    {
        _field.hidePlaceHolder = NO;
        
    }
    
    if (_field.text.length && _textView.text.length>3) {
        _sendBtn.userInteractionEnabled = YES;
        _sendLbl.textColor = [UIColor blackColor];
    } else{
        _sendBtn.userInteractionEnabled = NO;
        _sendLbl.textColor = Color178;
    }
    
}
#pragma mark --- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _previousSelection = textField.selectedTextRange;
    _previousTextFieldContent = textField.text;
    
    return YES;
}

#pragma mark --- 键盘发生变化后通知
- (void)keyBoardChanged:(NSNotification *)note
{
    
    // 键盘的大小
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 键盘出现的时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (frame.origin.y == HEIGHT) {   // 当键盘没有弹出的时候
        
        [UIView animateWithDuration:duration animations:^{
            
            _selectPicView.transform = CGAffineTransformIdentity;
//            _selectPicView.frame = CGRectMake(0, HEIGHT, WIDTH, 40 * IPHONE6_H_SCALE);
            
        }];
    } else
    {
        [UIView animateWithDuration:duration animations:^{
            
            _selectPicView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height );
//            _selectPicView.frame = CGRectMake(0, HEIGHT - 64-frame.size.height-40*IPHONE6_H_SCALE, WIDTH, 40 * IPHONE6_H_SCALE);
//            _selectPicView.frame = CGRectMake(0, 50, WIDTH, 40 * IPHONE6_H_SCALE);
        }];
    }
}

#pragma mark --- 添加选择发布图片的视图
- (void)addSelectPicView{
    UIView * selectPicView = [[UIView alloc] initWithFrame:CGRectMake(0,HEIGHT-40 * IPHONE6_H_SCALE-64, WIDTH, 40 * IPHONE6_H_SCALE)];
    selectPicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectPicView];
    _selectPicView = selectPicView;
    
    UIButton * picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPicView addSubview:picBtn];
    picBtn.frame = CGRectMake(25*IPHONE6_W_SCALE, 10 * IPHONE6_H_SCALE, 24*IPHONE6_W_SCALE, 20*IPHONE6_W_SCALE);
    [picBtn setImage:[UIImage imageNamed:@"icon_zhaopian"] forState:UIControlStateNormal];
    // 为按钮添加选择发布图片的事件
    [picBtn addTarget:self action:@selector(selectPic) forControlEvents:UIControlEventTouchUpInside];
    _picBtn = picBtn;
    
    // 选取牌谱按钮
    UIButton * pokersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pokersBtn setImage:[UIImage imageNamed:@"fapaipu"] forState:UIControlStateNormal];
    [selectPicView addSubview:pokersBtn];
    [pokersBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(picBtn.mas_right).offset(25 * IPHONE6_W_SCALE);
        make.top.equalTo(selectPicView.mas_top).offset(9 * IPHONE6_H_SCALE);
        make.width.equalTo(@(19 * IPHONE6_W_SCALE));
        make.height.equalTo(@(21 * IPHONE6_W_SCALE));
    }];
    [pokersBtn addTarget:self action:@selector(selectPoker) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * upLine = [[UIView alloc] init];
    upLine.backgroundColor = Color238;
    [selectPicView addSubview:upLine];
    
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = Color216;
    [selectPicView addSubview:bottomLine];
    
    upLine.frame = CGRectMake(0, 0, WIDTH, 0.5);
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectPicView.mas_left);
        make.right.equalTo(selectPicView.mas_right);
        make.bottom.equalTo(selectPicView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    

}

- (void)selectPoker{
    
    NSLog(@"跳到牌谱页面");
    if (self.imagesArr.count <9) {
        
        if (!_pictureView) {
            _pictureView = [X_SelectPicView shareSelectPicView];
            _pictureView.delegate = self;
            
            [self.view addSubview:_pictureView];
            
            __block typeof(self) weakSelf = self;
            _pictureView.Commplete = ^{ //跳转到相册
                if (self.imagesArr.count < 9) {
                    
                    NSLog(@"再次跳转到相册。。。");
                    
                    ImgPickerViewController* vc=[[ImgPickerViewController alloc]initWithSelectedPics:weakSelf.imagesArr.count];
                    
                    NSLog(@"0已选图片数：%lu", weakSelf.imagesArr.count);
                    
                    [weakSelf presentViewController:vc animated:YES completion:nil];
                    [vc setSelectOriginals:^(NSArray * Originals) {
                        [weakSelf.imagesArr addObjectsFromArray:Originals];
                        _pictureView.dataSource = weakSelf.imagesArr;
                    }];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"最多选择九张图片"];
                }
                
            };
        }

        MyPokersVC * myPokerVC = [[MyPokersVC alloc] init];
        [myPokerVC returnText:^(NSArray *imageArr) {
            
            NSLog(@"101010%@", imageArr);
            [self.imagesArr addObjectsFromArray:imageArr];
            _pictureView.dataSource = self.imagesArr;
        }];
        myPokerVC.selectedNumOfPic = self.imagesArr.count;
        [self presentViewController:myPokerVC animated:YES completion:nil];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"最多选九张图片"];
    }

}

#pragma mark ---- 选择图片的事件
- (void)selectPic{
    
    NSLog(@"跳转到相册....");
    
    NSArray * origainals = [NSArray array];
    _Originals = origainals;
    if (self.imagesArr.count <9) {
        
        ImgPickerViewController* vc=[[ImgPickerViewController alloc]init];
//        _vc = vc;
        [self presentViewController:vc animated:YES completion:nil];
        
        [vc setSelectOriginals:^(NSArray *Originals) {
            
            
            [self.imagesArr addObjectsFromArray:Originals];
            if (!_pictureView) {
                _pictureView = [X_SelectPicView shareSelectPicView];
                _pictureView.delegate = self;
                
                __block typeof(self) weakSelf = self;
                _pictureView.Commplete = ^{ //跳转到相册
                    if (self.imagesArr.count < 9) {
                        
                        NSLog(@"再次跳转到相册。。。");
                        
                        ImgPickerViewController* vc=[[ImgPickerViewController alloc]initWithSelectedPics:weakSelf.imagesArr.count];
                        
                        NSLog(@"0已选图片数：%lu", weakSelf.imagesArr.count);
                        
                        [weakSelf presentViewController:vc animated:YES completion:nil];
                        [vc setSelectOriginals:^(NSArray * Originals) {
                            [weakSelf.imagesArr addObjectsFromArray:Originals];
                            weakSelf.pictureView.dataSource = weakSelf.imagesArr;
//                            _pictureView.dataSource = weakSelf.imagesArr;
                        }];
                    }else{
                        [SVProgressHUD showSuccessWithStatus:@"最多选择九张图片"];
                    }
                    
                };
                
                [self.view addSubview:_pictureView];
            }
            
            _pictureView.dataSource = self.imagesArr;
            
            
        }];

    }else{
        [SVProgressHUD showErrorWithStatus:@"最多选九张图片"];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //    NSLog(@"%s", __func__);
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        // 返回
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imagesArr addObject:image];
        if (!_pictureView) {
            _pictureView = [X_SelectPicView shareSelectPicView];
            _pictureView.delegate = self;
            
            __block typeof(self) weakSelf = self;
            _pictureView.Commplete = ^{ //跳转到相册
                if (self.imagesArr.count < 9) {
                    [weakSelf presentViewController:_imagePicker animated:YES completion:nil];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"最多选择九张图片"];
                }
                
            };
            
            [self.view addSubview:_pictureView];
        }

        _pictureView.dataSource = self.imagesArr;
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 返回
        [self dismissViewControllerAnimated:YES completion:nil];
        // 保存编辑后的照片
    }
        
}


#pragma mark - X_SelectPicViewDelegate
- (void)didSelectPicView:(X_SelectPicView *)view atIndex:(NSInteger)index{
    NSLog(@"您选中了第%ld长图片",(long)index);
    NSLog(@"图片数组%@", _selectPictures);
}

// 删除已经选中的图片
- (void)deletePicView:(X_SelectPicView *)view atIndex:(NSInteger)index{
    NSLog(@"%ld\n",(long)index);
    [_selectPictures removeObjectAtIndex:index];
    [self.imagesArr removeObjectAtIndex:index];
    view.dataSource = self.imagesArr;
}
// 选择牌谱
- (void)didSelectPoker:(X_SelectPicView *)view{
    
    if (self.imagesArr.count <9) {
        
        MyPokersVC * myPokerVC = [[MyPokersVC alloc] init];
        [myPokerVC returnText:^(NSArray *imageArr) {
            
//            NSLog(@"%@", imageArr);
            
            [self.imagesArr addObjectsFromArray:imageArr];
            _pictureView.dataSource = self.imagesArr;
        }];
        
        myPokerVC.selectedNumOfPic = self.imagesArr.count;
        [self presentViewController:myPokerVC animated:YES completion:nil];
        
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"最多选九张图片"];
    }
}
// 图片的位置发生变化
- (void)indexOfPicsChanged:(NSMutableArray *)imageArr{
    
    self.imagesArr = imageArr;
//    [self.imagesArr removeLastObject];
}


- (void)deletePicWithIndex:(NSInteger)index{
    // 移除添加的图片r
    NSLog(@"移除添加的图片");
    [self.imagesArr removeObjectAtIndex:index];
}

#pragma mark --- 添加textView
- (void)addTextView{
    LSTextView * textView = [[LSTextView alloc] init];
    textView.text = @"   ";
    
    [self.view addSubview:textView];
    CGFloat y = CGRectGetMaxY(_field.frame);
    textView.frame = CGRectMake(0, y, WIDTH, 250 * IPHONE6_H_SCALE);
//    textView.backgroundColor = [UIColor greenColor];
    textView.delegate = self;
    // 允许textView垂直方向拖动
    textView.alwaysBounceVertical = YES;
    textView.font = Font13;
    textView.placeHolderLabel.textColor = Color178;
    textView.placeholder = @"没事写两句";
    
    //  占位符距离左、上的距离
    textView.placeHolderX = 18*IPHONE6_W_SCALE;
    textView.placeHolderY = 7 * IPHONE6_H_SCALE;
    
//    self.mytextfiled.contentInset = UIEdgeInsetsMake(-24, -6, 0, 0);
    // 上、左、下、右
//    textView.contentInset = UIEdgeInsetsMake(10 * IPHONE6_H_SCALE, 18*IPHONE6_W_SCALE, 0, 0);
    
    
    _textView = textView;
   
}



#pragma mark --- textView的内容发生变化后进行调用
- (void)textViewChanged
{
    // 如果有内容就隐藏占位符，没有内容就显示占位符
    if (_textView.text.length ) {
        _textView.hidePlaceHolder = YES;
        
    } else
    {
        _textView.hidePlaceHolder = NO;
        
    }
    
    if (_field.text.length && _textView.text.length > 3) {
        _sendBtn.userInteractionEnabled = YES;
        _sendLbl.textColor = [UIColor blackColor];
    } else{
        _sendBtn.userInteractionEnabled = NO;
        _sendLbl.textColor = Color178;
    }
   
}
#pragma mark -------- UITextViewDelegate
// 滚动视图开始滑动的时候调用此方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    [_textView resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)setUpPicturesView
{
   
}

@end
