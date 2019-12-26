//
//  HpBinaryReader.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#include <stdio.h>

class HpBinaryReader {
    FILE* _fp;
    char _buffer[128];

public:
    HpBinaryReader(const char* p_file);
    ~HpBinaryReader();
    void close();
    size_t read(char* buffer, int count);
    bool readBoolean();
    char readChar();
    size_t readChars(char* buffer, int count);
    unsigned char readByte();
    double readDouble();
    short readInt16();
    int readInt32();
    long readInt64();
    float readSingle();
    size_t readString(char* buffer);
    unsigned short readUInt16();
    unsigned int readUInt32();
    unsigned long readUInt64();
};
