//
//  OFPersonalInfoVC.m
//  OFBank
//
//  Created by xiepengxiang on 12/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFPersonalInfoVC.h"
#import "OFPersonalInfoLogic.h"
#import "OFPersonalInfoCell.h"
#import "UIImage+reDraw.h"
#import <AVFoundation/AVFoundation.h>

@interface OFPersonalInfoVC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,OFPersonalInfoCellDelegate>

@property (nonatomic, strong) OFPersonalInfoLogic *logic;

@end

@implementation OFPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.view.backgroundColor = OF_COLOR_BACKGROUND;
    self.tableView.backgroundColor = OF_COLOR_CLEAR;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.tableView registerClass:[OFPersonalInfoCell class] forCellReuseIdentifier:kOFPersonalInfoCellIdentifier];
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
}

- (void)initData
{
    self.title = @"个人信息";
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

#pragma mark - Action
- (void)changeAvatar:(NSInteger)index
{
    NSLog(@"%ld", index);
    if (index == 1) {
        [self photoChoose];
    }else if (index == 2) {
        [self cameraChoose];
    }
}

- (void)photoChoose
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)cameraChoose
{
    BOOL isComera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isComera){ //没有摄像头
        [self AlertWithTitle:@"无法使用相机" message:@"此设备没有摄像头" andOthers:@[@"确定"] animated:YES action:nil];
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [self AlertWithTitle:@"无法使用相机" message:@"请在ipone的“设置-隐私-相机”中允许访问相机" andOthers:@[@"确定"] animated:YES action:nil];
        return;
    }
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.allowsEditing = YES;
    NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerController.sourceType];
    pickerController.mediaTypes = temp_MediaTypes;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark - 获得图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newImage = [image compressImage];
    NSData *imgData = UIImagePNGRepresentation(newImage);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.logic updateUserAvatar:imgData withBlock:^(bool suc, NSString *avatar, NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:self.view];
        if (suc) {
            [MBProgressHUD showSuccess:errorMessage];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:errorMessage];
        }
    }];    
}

#pragma mark - OFPersonalInfoCellDelegate
- (void)infoCell:(OFPersonalInfoCell *)infoCell didEditNickname:(NSString *)nickName
{
    [self.logic updateUserName:nickName withBlock:^(bool suc, NSString *errorMessage) {
        if (!suc) {
            [MBProgressHUD showError:errorMessage];
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logic itemCountOfSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOFPersonalInfoCellIdentifier];
    OFPersonalInfoItem *item = [self.logic itemAtIndex:indexPath];
    [cell setItem:item];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    OFPersonalInfoItem *item = [self.logic itemAtIndex:indexPath];
    if (item.type == PersonalInfoCellAvatar) {
        WEAK_SELF;
        [self ActionSheetWithTitle:nil message:nil destructive:nil destructiveAction:nil andOthers:@[@"取消",@"相册",@"相机"] animated:YES action:^(NSInteger index) {
            [weakSelf changeAvatar:index];
        }];
    }else if(item.type == PersonalInfoCellName) {
        OFPersonalInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell becomeResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kOFPersonalInfoCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEdit];
}

#pragma mark - lazy load
- (OFPersonalInfoLogic *)logic
{
    if (!_logic) {
        _logic = [[OFPersonalInfoLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

@end
