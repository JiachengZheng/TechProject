//
//  TPEncodeAndDecoded.h
//  TechProject
//
//  Created by zhengjiacheng on 2018/1/17.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

#ifndef TPEncodeAndDecoded_h
#define TPEncodeAndDecoded_h
#import <objc/runtime.h>
#define ENCODED_AND_DECODED() \
\
- (instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
Class cls = [self class];\
while (cls != [NSObject class]) {\
BOOL bIsSelfClass = (cls == [self class]);\
unsigned int iVarCount = 0;\
unsigned int proVarCount = 0;\
unsigned int shareVarCount = 0;\
\
Ivar *ivarList = bIsSelfClass? class_copyIvarList([cls class], &iVarCount):NULL;\
objc_property_t *proVarList = bIsSelfClass?NULL:class_copyPropertyList(cls, &proVarCount);\
shareVarCount = bIsSelfClass?iVarCount:proVarCount;\
for (int i = 0; i < shareVarCount; i++) {\
const char *varName = bIsSelfClass? ivar_getName(*(ivarList + i)):property_getName(*(proVarList + i));\
NSString *key = [NSString stringWithUTF8String:varName];\
id varValue = [aDecoder decodeObjectForKey:key];\
if (varValue) {\
[self setValue:varValue forKey:key];\
}\
}\
free(ivarList);\
free(proVarList);\
cls = class_getSuperclass(cls);\
}\
return self;\
}\
- (void)encodeWithCoder:(NSCoder *)aCoder{\
Class cls = [self class];\
while (cls != [NSObject class]) {\
BOOL bIsSelfClass = (cls == [self class]);\
unsigned int iVarCount = 0;\
unsigned int proVarCount = 0;\
unsigned int shareVarCount = 0;\
\
Ivar *ivarList = bIsSelfClass? class_copyIvarList([cls class], &iVarCount):NULL;\
objc_property_t *proVarList = bIsSelfClass?NULL:class_copyPropertyList(cls, &proVarCount);\
shareVarCount = bIsSelfClass?iVarCount:proVarCount;\
for (int i = 0; i < shareVarCount; i++) {\
const char *varName = bIsSelfClass? ivar_getName(*(ivarList + i)):property_getName(*(proVarList + i));\
NSString *key = [NSString stringWithUTF8String:varName];\
id varValue = [self valueForKey:key];\
if (varValue) {\
[aCoder encodeObject:varValue forKey:key];\
}\
}\
free(ivarList);\
free(proVarList);\
cls = class_getSuperclass(cls);\
}\
}

#endif /* TPEncodeAndDecoded_h */
