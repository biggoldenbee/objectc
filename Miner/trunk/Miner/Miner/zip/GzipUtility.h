// ͷ�ļ���GzipUtility.h

#import <Foundation/Foundation.h>

@interface GzipUtility : NSObject

        // ����ѹ��

        + ( NSData *)compressData:( NSData *)uncompressedData;  

        // ���ݽ�ѹ��

        + ( NSData *)decompressData:( NSData *)compressedData;

@end