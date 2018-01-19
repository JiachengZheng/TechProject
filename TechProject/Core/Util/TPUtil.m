//
//  TPUtil.m
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/17.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#import "TPUtil.h"

@implementation TPUtil
+ (void)showAlert:(NSString *)message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:confirm];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

+ (NSString *)generateUUID{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}

+ (void)cleanInboxFiles{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    docDir = [docDir stringByAppendingString:@"/Inbox"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:docDir];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[docDir stringByAppendingPathComponent:fileName] error:nil];
    }
}
@end
