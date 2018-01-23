//
//  TPClientInfoEditVCL.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/22.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPClientInfoEditVCL.h"
#import "TPProjectDataManager.h"
#import "TPUtil.h"
@interface TPClientInfoEditVCL ()
@property (weak, nonatomic) IBOutlet UITextView *editView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation TPClientInfoEditVCL

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNaviBar];
    self.saveBtn.layer.cornerRadius = 4;
    self.editView.text = self.editValue;
    self.editView.layer.cornerRadius = 3;
    self.editView.layer.borderWidth = 0.5;
    self.editView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Do any additional setup after loading the view.
}

- (void)addNaviBar{
    UIView *naviBar = [TPCommonViewHelper createNavigationBar:self.editType enableBackButton:YES];
    [self.view addSubview:naviBar];
}

- (void)showSaveAlert{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认修改吗？" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) instance = self;
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [instance saveAction];
        [instance.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:confirm];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancel];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)saveAction{
    NSString *value = self.editView.text;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.client.infoArr];
    NSInteger i = 0;
    for (NSDictionary *dic in self.client.infoArr) {
        for (NSString *key in dic) {
            if ([key isEqualToString:self.editType]) {
                NSDictionary *d = @{key: value};
                [arr replaceObjectAtIndex:i withObject:d];
                break;
            }
        }
        i++;
    }
    self.client.infoArr = [arr copy];
    [[TPProjectDataManager shareInstance]saveClientData:self.client];
}

- (IBAction)clickSave:(id)sender {
    [self showSaveAlert];
}

@end
