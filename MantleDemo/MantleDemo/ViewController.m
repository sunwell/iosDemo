//
//  ViewController.m
//  MantleDemo
//
//  Created by sunwell on 2016/9/25.
//  Copyright © 2016年 com.sun.mantledemo. All rights reserved.
//

#import "ViewController.h"
#import "SSGiftSubscribeTableCell.h"
#import "SSConstant.h"
#import "SSScrollView.h"
#import "SSToolsClass.h"


@interface ViewController () <SSScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *ssPubInfoArr; //存储服务器端请求回来的数据
//    int page;
//    SSNoInternetView *noView;
    SSScrollView *titleScrollView;
}

@property (weak, nonatomic) IBOutlet UITableView *ssTableView;
@property (nonatomic) NSArray *ssGiftCateArr; //礼品分类数据
@property (nonatomic, copy) NSString *ssItemId;  //分类id
@property (nonatomic,copy) NSString *ssType;

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.ssTableView registerNib:[UINib nibWithNibName:ST_GIFT_GiftSubscribeTableCellIdentifier bundle:nil] forCellReuseIdentifier:ST_GIFT_GiftSubscribeTableCellIdentifier];
    self.ssTableView.rowHeight = 290;
    
    titleScrollView = [[SSScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    titleScrollView.ssDelegate = self;
    titleScrollView.titleColor = @"66ccb6";
    titleScrollView.isTipViewShow = NO;
    [self.view addSubview:titleScrollView];
    [self requestCateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate method
#pragma mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ssPubInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSGiftSubscribeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ST_GIFT_GiftSubscribeTableCellIdentifier];
    cell.ssGiftV.userInteractionEnabled = YES;
    [cell configCellWithData:ssPubInfoArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark  UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark  SSScrollViewDelegate
- (void)refreshTableWithTitleIndex:(NSInteger)titleIndex {
    SSCategoryInfo *cateInfo = self.ssGiftCateArr[titleIndex];
    self.ssItemId = cateInfo.ssId;
    [self requestData];
}

#pragma mark - event response


#pragma mark - private method
- (void)requestData {
    NSString *url = [SSUrlAPI getGiftListURLWithItemId:self.ssItemId page:1 count:@"10"];
    [[SSInterFace shareInterFace] getSubscribeGiftListInfo_interface:url success:^(id responseData) {

        if (ssPubInfoArr) {
            [ssPubInfoArr addObjectsFromArray:responseData];
        } else {
            ssPubInfoArr = [NSMutableArray array];
            [ssPubInfoArr addObjectsFromArray:responseData];
        }
        
        [self.ssTableView reloadData];
    } failure:^(id errorData) {
    }];
}

- (void)requestCateData {
    NSString *url = [SSUrlAPI getGiftCategory];
    [[SSInterFace shareInterFace] getGiftCate_interface:url success:^(id responseData) {
        self.ssGiftCateArr = [NSArray arrayWithArray:responseData];
        SSCategoryInfo *cateInfo = self.ssGiftCateArr[0];
        
        self.ssItemId = cateInfo.ssId;  //保存第一个分类id，刷新的时候需要用到
        self.ssType = cateInfo.ssType;
        NSMutableArray *arr = [NSMutableArray array];
        for (SSCategoryInfo *info in self.ssGiftCateArr) {
            if ([info.ssType isEqualToString:@"y"]) {
                [arr addObject:info];
            }
        }
        self.ssGiftCateArr = arr;
        [titleScrollView configData:arr];
        
        [self requestData];
    } failure:^(id errorData) {
    }];
}

@end
