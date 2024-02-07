//
//  BaseFilter.cpp
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

#include "BaseFilter.hpp"
#include "CanvasRenderData.hpp"
#include <CommonCrypto/CommonDigest.h>
#include <iostream>
#include <string>

BaseFilter::BaseFilter() {
    
}

BaseFilter::BaseFilter(const char *vs, const char *fs) {
    this->vs = vs;
    this->fs = fs;
    this->identify = md5(vs, fs);
    program = 0;
    
    CanvasRenderData::createProgram(program, this->vs, this->fs);
}

const char* BaseFilter::md5(const char *vs, const char *fs) {
    std::string concatenated(vs);
    concatenated += fs;

    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concatenated.c_str(), (CC_LONG)concatenated.length(), digest);

    char mdString[CC_MD5_DIGEST_LENGTH * 2 + 1];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        sprintf(&mdString[i * 2], "%02x", (unsigned int)digest[i]);

    mdString[CC_MD5_DIGEST_LENGTH * 2] = '\0';
    return strdup(mdString);
}

void BaseFilter::configUniform() {
}
