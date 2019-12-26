//
//  HpBinaryReader.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#include "HpBinaryReader.h"
#include <memory.h>


HpBinaryReader::HpBinaryReader(const char* p_file)
{
    _fp = fopen(p_file, "rb");
}

HpBinaryReader::~HpBinaryReader()
{
    close();
}

void HpBinaryReader::close()
{
    if (_fp) {
        fclose(_fp);
        _fp = nullptr;
    }
}

size_t HpBinaryReader::read(char* buffer, int count)
{
    memset(buffer, 0, count);
    return fread(buffer, sizeof(char), count, _fp);
}

bool HpBinaryReader::readBoolean()
{
    fread(_buffer, sizeof(char), 1, _fp);
    return _buffer[0] != 0;
}

char HpBinaryReader::readChar()
{
    fread(_buffer, sizeof(char), 1, _fp);
    return _buffer[0];
}

size_t HpBinaryReader::readChars(char* buffer, int count)
{
    return fread(buffer, sizeof(char), count, _fp);
}

unsigned char HpBinaryReader::readByte()
{
    fread(_buffer, sizeof(unsigned char), 1, _fp);
    return *((unsigned char*)_buffer);

}

double HpBinaryReader::readDouble()
{
    fread(_buffer, sizeof(double), 1, _fp);
    return *((double*)_buffer);
}

short HpBinaryReader::readInt16()
{
    fread(_buffer, sizeof(short), 1, _fp);
    return *((short*)_buffer);
}

int HpBinaryReader::readInt32()
{
    fread(_buffer, sizeof(int), 1, _fp);
    return *((int*)_buffer);
}

long HpBinaryReader::readInt64()
{
    fread(_buffer, sizeof(long), 1, _fp);
    return *((long*)_buffer);
}

float HpBinaryReader::readSingle()
{
    fread(_buffer, sizeof(float), 1, _fp);
    return *((float*)_buffer);
}

size_t HpBinaryReader::readString(char* buffer)
{
    unsigned char len = readByte();
    memset(buffer, 0, len+1);
    return  readChars(buffer, len);
}

unsigned short HpBinaryReader::readUInt16()
{
    fread(_buffer, sizeof(unsigned short), 1, _fp);
    return *((unsigned short*)_buffer);
}

unsigned int HpBinaryReader::readUInt32()
{
    fread(_buffer, sizeof(unsigned int), 1, _fp);
    return *((unsigned int*)_buffer);
}

unsigned long HpBinaryReader::readUInt64()
{
    fread(_buffer, sizeof(unsigned long), 1, _fp);
    return *((unsigned long*)_buffer);
}

