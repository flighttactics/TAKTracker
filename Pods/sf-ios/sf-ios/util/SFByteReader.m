//
//  SFByteReader.m
//  sf-ios
//
//  Created by Brian Osborn on 5/28/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFByteReader.h"

@implementation SFByteReader

-(instancetype) initWithData: (NSData *) bytes{
    self = [self initWithData:bytes andByteOrder:DEFAULT_READ_BYTE_ORDER];
    return self;
}

-(instancetype) initWithData: (NSData *) bytes andByteOrder: (CFByteOrder) byteOrder{
    self = [super init];
    if(self != nil){
        self.bytes = bytes;
        self.nextByte = 0;
        self.byteOrder = byteOrder;
    }
    return self;
}

-(NSString *) readString: (int) num{
    char *buffer = (char *)malloc(sizeof(char) * (num +1));
    int rangeStart = self.nextByte;
    [self.bytes getBytes:buffer range:NSMakeRange(rangeStart, num)];
    buffer[num] = '\0';
    NSString *value = [NSString stringWithUTF8String:buffer];
    self.nextByte += num;
    free(buffer);
    return value;
}

-(NSNumber *) readByte{
    char *buffer = (char *)malloc(sizeof(char));
    int rangeStart = self.nextByte;
    [self.bytes getBytes:buffer range:NSMakeRange(rangeStart, 1)];
    uint8_t value = *(uint8_t*)buffer;
    self.nextByte++;
    free(buffer);
    return [NSNumber numberWithInt:value];
}

-(NSData *) readData: (int) num{
    int rangeStart = self.nextByte;
    NSData *data = [self.bytes subdataWithRange:NSMakeRange(rangeStart, num)];
    self.nextByte += num;
    return data;
}

-(NSNumber *) readInt{
    char *buffer = (char *)malloc(sizeof(char) * 4);
    int rangeStart = self.nextByte;
    [self.bytes getBytes:buffer range:NSMakeRange(rangeStart, 4)];
    
    uint32_t result = *(uint32_t*)buffer;
    
    if(self.byteOrder == CFByteOrderBigEndian){
        result = CFSwapInt32BigToHost(result);
    }else{
        result = CFSwapInt32LittleToHost(result);
    }
    
    self.nextByte += 4;
    free(buffer);
    
    return [NSNumber numberWithInt:result];
}

-(NSDecimalNumber *) readDouble{
    char *buffer = (char *)malloc(sizeof(char) * 8);
    int rangeStart = self.nextByte;
    [self.bytes getBytes:buffer range:NSMakeRange(rangeStart, 8)];
    
    union DoubleSwap {
        double v;
        uint64_t sv;
    } result;
    result.sv = *(uint64_t*)buffer;
    
    if(self.byteOrder == CFByteOrderBigEndian){
        result.sv = CFSwapInt64BigToHost(result.sv);
    }else{
        result.sv = CFSwapInt64LittleToHost(result.sv);
    }
    
    self.nextByte += 8;
    free(buffer);
    
    return [[NSDecimalNumber alloc] initWithDouble:result.v];
}

@end
