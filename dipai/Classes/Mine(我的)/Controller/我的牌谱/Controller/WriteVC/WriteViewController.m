//
//  WriteViewController.m
//  dipai
//
//  Created by 梁森 on 16/9/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "WriteViewController.h"

#import "NavigationBarV.h"
#import "LSTextView.h"
#import "Masonry.h"
#import "SVProgressHUD.h"

// 牌谱详情页
#import "DetailPokerVC.h"
// 编辑单元格
#import "StandardCell.h"
@interface WriteViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, StandardCellDelegate>

@property (nonatomic, strong) LSTextView * textView;

@property (nonatomic, strong) UILabel     * placeLbl;

@property (nonatomic, strong) UIView      * blackBacV;

@property (nonatomic, strong) UIView      * whiteBackV;
// 标准模式下的一个编辑表格
@property (nonatomic, strong) UITableView * tableV;

@property (nonatomic, strong) NSMutableArray * textArr;

@property (nonatomic, strong) NSMutableArray * tableArr;

// 编辑信息
@property (nonatomic, copy) NSString * text1;
@property (nonatomic, copy) NSString * text2;
@property (nonatomic, copy) NSString * text3;
@property (nonatomic, copy) NSString * text4;
@property (nonatomic, copy) NSString * text5;

@end

@implementation WriteViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (NSMutableArray *)textArr{
    
    if (_textArr == nil) {
        _textArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _textArr;
}

- (NSMutableArray *)tableArr{
    
    if (_tableArr == nil) {
        _tableArr = [NSMutableArray array];
    }
    return _tableArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // 添加标准页面
    [self setStandUI];
    
    // 添加自定义页面
    [self setUpUI];
    
    // 对UITextView添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged) name:UITextViewTextDidChangeNotification object:nil];
    
    //开始编辑
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginediting:) name:UITextViewTextDidBeginEditingNotification object:self];
}

-(void)beginediting:(NSNotification *)notification
{
    NSLog(@"开始编辑");
}

- (void)setUpUI {
    
    UIView * whiteBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    whiteBackV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBackV];
    _whiteBackV = whiteBackV;
    NavigationBarV * topV = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64 * IPHONE6_H_SCALE)];
    [whiteBackV addSubview:topV];
    topV.backgroundColor = [UIColor whiteColor];
    
    [topV.popBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [topV.rightBtn addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
    
    topV.leftStr = @"取消";
    topV.rightStr = @"预览";
    topV.titleStr = @"自定义编写";
    topV.color = [UIColor blackColor];
    
    CGFloat lineY = CGRectGetMaxY(topV.frame);
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, WIDTH, 1)];
    [whiteBackV addSubview:line];
    line.backgroundColor = RGBA(216, 216, 216, 1);
    
    LSTextView * textView = [[LSTextView alloc] init];
    //    textView.backgroundColor = [UIColor greenColor];
    
    [whiteBackV addSubview:textView];
//    [textView becomeFirstResponder];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(19 * IPHONE6_W_SCALE);
        make.right.equalTo(self.view.mas_right).offset(-19 * IPHONE6_W_SCALE);
        make.top.equalTo(line.mas_bottom).offset(11 * IPHONE6_H_SCALE);
        make.height.equalTo(@(300 * IPHONE6_H_SCALE));
    }];
    textView.delegate = self;
    // 允许textView垂直方向拖动
    textView.alwaysBounceVertical = YES;
    textView.font = Font13;
    UILabel * placeLbl = [[UILabel alloc] init];
    placeLbl.numberOfLines = 0;
    placeLbl.font = Font14;
    placeLbl.textColor = Color178;
    [textView addSubview:placeLbl];
    NSString * placeStr = @"您可以在此输入您的牌例，也可点击下方的切换按钮，按照我们给出的模版进行添加";
    placeLbl.text = placeStr;
    CGFloat placeW = WIDTH - 38 * IPHONE6_W_SCALE;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = Font14;
    CGRect rect = [placeStr boundingRectWithSize:CGSizeMake(placeW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    placeLbl.frame = (CGRect){{5*IPHONE6_W_SCALE, 6*IPHONE6_H_SCALE}, rect.size};
    
    //  占位符距离左、上的距离
    textView.placeHolderY = 0 * IPHONE6_H_SCALE;
    textView.placeHolderY = 0;
    _textView = textView;
    _placeLbl = placeLbl;
//    textView.backgroundColor = [UIColor greenColor];
    
    // 切换按钮
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"qiehuan"] forState:UIControlStateNormal];
    [whiteBackV addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-19 * IPHONE6_W_SCALE);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16 * IPHONE6_H_SCALE);
        make.width.equalTo(@(40 * IPHONE6_W_SCALE));
        make.height.equalTo(@(40 * IPHONE6_W_SCALE));
    }];
    [changeBtn addTarget:self action:@selector(changePage) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -- 切换页面
- (void)changePage{
    
    if (_textView.text.length > 0) {
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"确定切换至标准模式？" message:@"切换后，您已输入的内容将被舍弃" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _textView.text = @"";
            _placeLbl.hidden = NO;
            [self changePageToStandPage];
        }];
        
        [alertC addAction:cancle];
        [alertC addAction:ok];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        
        [self changePageToStandPage];
    }
}

- (void)changePageToStandPage{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 进行切换的动画
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    NSUInteger black = [[self.view subviews] indexOfObject:_blackBacV];
    NSUInteger white = [[self.view subviews] indexOfObject:_whiteBackV];
    [self.view exchangeSubviewAtIndex:black withSubviewAtIndex:white];
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用某个方法
    //[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textView resignFirstResponder];
}
#pragma mark -------- UITextViewDelegate
// 滚动视图开始滑动的时候调用此方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    [_textView resignFirstResponder];
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
       // 表格复原
        _tableV.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark --- textView的内容发生变化后进行调用
- (void)textViewChanged
{
    // 如果有内容就隐藏占位符，没有内容就显示占位符
    if (_textView.text && _textView.text.length > 0) {
        _placeLbl.hidden = YES;
        
    } else
    {
        _placeLbl.hidden = NO;
        
    }
    
}

- (void)dismissAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 预览事件
- (void)previewAction{
    NSLog(@"...");
    DetailPokerVC * detailPoker = [[DetailPokerVC alloc] init];
    if (_textView.text.length > 0) {
        detailPoker.text = _textView.text;
        detailPoker.userName = self.userName;
        [self.navigationController pushViewController:detailPoker animated:YES];
    }else{
        
        NSLog(@"没有编辑文字");
        [SVProgressHUD showErrorWithStatus:@"没有填写内容"];
    }
    
}

#pragma mark --- 标准页面
- (void)setStandUI{
    UIView * blackBacV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    blackBacV.backgroundColor = RGBA(23, 23, 23, 1);
    [self.view addSubview:blackBacV];
    _blackBacV = blackBacV;
    NavigationBarV * topV = [[NavigationBarV alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64 * IPHONE6_H_SCALE)];
//    [blackBacV addSubview:topV];
    topV.backgroundColor = [UIColor blackColor];
    
    [topV.popBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [topV.rightBtn addTarget:self action:@selector(previewForStand) forControlEvents:UIControlEventTouchUpInside];
    
    topV.leftStr = @"取消";
    topV.rightStr = @"预览";
    topV.titleStr = @"标准模式";
    topV.color = [UIColor whiteColor];
    
    CGFloat tableY = CGRectGetMaxY(topV.frame) + 14 * IPHONE6_H_SCALE;
    // 编辑表格
    UITableView * tableV = [[UITableView alloc] initWithFrame:CGRectMake(15 * IPHONE6_W_SCALE, tableY, WIDTH - 30 * IPHONE6_W_SCALE, HEIGHT - tableY ) style:UITableViewStylePlain];
    tableV.contentSize = CGSizeMake(WIDTH - 30 * IPHONE6_W_SCALE, HEIGHT + 250);
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = RGBA(23, 23, 23, 1);
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [blackBacV addSubview:tableV];
    _tableV = tableV;
    [blackBacV addSubview:topV];
    
    // 切换按钮
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [blackBacV addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(blackBacV.mas_right).offset(-19 * IPHONE6_W_SCALE);
        make.bottom.equalTo(blackBacV.mas_bottom).offset(-16 * IPHONE6_H_SCALE);
        make.width.equalTo(@(40 * IPHONE6_W_SCALE));
        make.height.equalTo(@(40 * IPHONE6_W_SCALE));
    }];
    [changeBtn setImage:[UIImage imageNamed:@"icon_qiehuan"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeBack{
    
    if (_text1.length > 0 || _text2.length > 0 || _text3.length > 0 || _text4.length > 0 || _text5.length > 0) {
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"确定切换至标准模式？" message:@"切换后，您已输入的内容将被舍弃" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            
        }];
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 清除所有编辑内容
            for (StandardCell * cell in self.tableArr) {
                cell.textV.text = @"";
            }
            [self changeBackSure];
        }];
        
        [alertC addAction:cancle];
        [alertC addAction:ok];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        
        [self changeBackSure];
    }
    
    
}

- (void)changeBackSure{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    NSUInteger white = [[self.view subviews] indexOfObject:_whiteBackV];
    NSUInteger black = [[self.view subviews] indexOfObject:_blackBacV];
    [self.view exchangeSubviewAtIndex:white withSubviewAtIndex:black];
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用某个方法
    [UIView commitAnimations];
    
}

// 标准预览
- (void)previewForStand{
    
//    NSLog(@"标准预览。。。");
//    NSLog(@"%@", self.tableArr);
    // 在预览的时候判断某个Cell是否隐藏
    
    for (StandardCell * cell in self.tableArr) {
//        NSLog(@"%lu", cell.textV.tag);
        
        if ([cell.hiddenBtn isSelected]) {
            switch (cell.textV.tag) {
                case 0:
                    _text1 = @"";
                    break;
                case 1:
                    _text2 = @"";
                    break;
                case 2:
                    _text3 = @"";
                    break;
                case 3:
                    _text4 = @"";
                    break;
                case 4:
                    _text5 = @"";
                    break;
                default:
                    break;
            }
        }
    }
    
    DetailPokerVC * detailVC = [[DetailPokerVC alloc] init];
    if (_text1 == nil) {
        _text1 = @"";
    }
    if (_text2 == nil) {
        _text2 = @"";
    }
    if (_text3 == nil) {
        _text3 = @"";
    }
    if (_text4 == nil) {
        _text4 = @"";
    }
    if (_text5 == nil) {
        _text5 = @"";
    }
    [self.textArr removeAllObjects];
    [self.textArr addObject:_text1];
    [self.textArr addObject:_text2];
    [self.textArr addObject:_text3];
    [self.textArr addObject:_text4];
    [self.textArr addObject:_text5];
    
    detailVC.textArr = self.textArr;
    if (_text1.length == 0 && _text2.length == 0 && _text3.length == 0 && _text4.length == 0 && _text5.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"没有填写内容"];
    }else{
        
        detailVC.userName = self.userName;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
//    [self.textArr removeAllObjects];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case 0:
            NSLog(@"green");
            break;
        case 1:
            NSLog(@"red");
            break;
        case 2:
            NSLog(@"blue");
            break;
        case 3:
            _tableV.transform = CGAffineTransformMakeTranslation(0, -100 * IPHONE6_H_SCALE);
            break;
        case 4:
            _tableV.transform = CGAffineTransformMakeTranslation(0, -250 * IPHONE6_H_SCALE);
            break;
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StandardCell * cell = [StandardCell cellWithTableView:tableView];
    cell.textV.delegate = self;
    cell.textV.tag = indexPath.row;
    cell.delegate = self;
    cell.backgroundColor = RGBA(23, 23, 23, 1);
    
    switch (indexPath.row) {
        case 0:
            cell.titleLbl.text = @"牌局基本信息";
            break;
        case 1:
            cell.titleLbl.text = @"Preflop";
            break;
        case 2:
            cell.titleLbl.text = @"Flop";
            break;
        case 3:
            cell.titleLbl.text = @"Turn";
            break;
        case 4:
            cell.titleLbl.text = @"River";
            break;
        default:
            break;
    }
    if (self.tableArr.count < 5) {
        [self.tableArr addObject:cell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
}

- (void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"%@", textView.text);
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSLog(@"text值%@", textView.text);
    NSLog(@"tag值%lu", textView.tag);
    switch (textView.tag) {
        case 0:
            _text1 = textView.text;
            break;
        case 1:
            _text2 = textView.text;
            break;
        case 2:
            _text3 = textView.text;
            break;
        case 3:
            _text4 = textView.text;
            break;
        case 4:
            _text5 = textView.text;
            break;
        default:
            break;
    }
}

// 隐藏按钮的点击事件
- (void)tableViewCell:(StandardCell *)cell{
    
//    NSLog(@"%lu", cell.textV.tag);
    cell.hiddenBtn.selected = !cell.hiddenBtn.selected;
    if ([cell.hiddenBtn isSelected]) {
        
        [cell.hiddenBtn setImage:[UIImage imageNamed:@"icon_xianshi"] forState:UIControlStateNormal];
        cell.titleLbl.textColor = RGBA(95, 95, 95, 1);
        cell.textV.textColor = RGBA(71, 70, 70, 1);
        cell.backgroundColor = RGBA(32, 32, 32, 1);
        cell.textV.userInteractionEnabled = NO; // 不能进行编辑
    }else{
        
        [cell.hiddenBtn setImage:[UIImage imageNamed:@"icon_yincang"] forState:UIControlStateNormal];
        cell.titleLbl.textColor = [UIColor whiteColor];
        cell.textV.textColor = RGBA(178, 178, 178, 1);
        cell.backgroundColor = RGBA(54, 54, 54, 1);
        cell.textV.userInteractionEnabled = YES;
        cell.backV.layer.cornerRadius = 4;
        [cell.textV becomeFirstResponder];
        
        // 设置UITextView光标的位置
        NSRange range;
        range.location = 0;
        range.length = 0;
        cell.textV.selectedRange = range;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130 * IPHONE6_H_SCALE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
