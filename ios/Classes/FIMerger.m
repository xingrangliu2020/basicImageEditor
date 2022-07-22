//
//  FIMerger.m
//  GPUImage
//
//  Created by Caijinglong on 2020/5/27.
//

#import "FIMerger.h"
#import "EditorUIImageHandler.h"

@implementation FIMerger

- (NSData *)process {
    FIMergeOption *opt = self.option;
    UIGraphicsBeginImageContext(opt.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) {
        return nil;
    }
    for (FIMergeImage *mergeImage in opt.images) {
        UIImage *image = [UIImage imageWithData:mergeImage.data];
        image = [EditorUIImageHandler fixImageOrientation:image];
        [image drawInRect:CGRectMake(mergeImage.x, mergeImage.y, mergeImage.width, mergeImage.height)];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage) {
        return nil;
    }
    return [self outputMemory:newImage];
}

- (NSData *)outputMemory:(UIImage *)image {
    FIFormatOption *fmt = self.option.format;
    if (fmt.format == 0) {
        return UIImagePNGRepresentation(image);
    } else {
        return UIImageJPEGRepresentation(image, ((CGFloat)fmt.quality) / 100);
    }
}

- (NSString *)makeOutputPath {
    NSString *extName = self.option.format.format == 1 ? @"jpg" : @"png";
    NSString *cachePath =
    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    long time = (long)[NSDate date].timeIntervalSince1970;
    return [NSString stringWithFormat:@"%@/%ld.%@", cachePath, time, extName];
}

@end
