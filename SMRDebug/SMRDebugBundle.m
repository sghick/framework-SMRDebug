//
//  SMRDebugBundle.m
//  SMRDebugDemo
//
//  Created by Tinswin on 2020/5/27.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRDebugBundle.h"

@implementation SMRDebugBundle

+ (instancetype)sourceBundle {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:NSStringFromClass(self.class) ofType:@"bundle"];
    SMRDebugBundle *bundle = [SMRDebugBundle bundleWithPath:path];
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name {
    NSString *pic_name = [name stringByDeletingPathExtension];
    NSString *path_extension = [name pathExtension].length?[name pathExtension]:@"png";
    NSString *imagePath = [[self sourceBundle] pathForResource:pic_name ofType:path_extension];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
