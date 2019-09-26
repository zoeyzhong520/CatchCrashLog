//
//  SingleHandle.h
//  Crash异常捕获
//
//  Created by zhifu360 on 2019/9/25.
//  Copyright © 2019 ZZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleHandle : NSObject

+ (void)saveCreash:(NSString *)exceptionInfo;

@end

void InstallSignalHandler(void);
