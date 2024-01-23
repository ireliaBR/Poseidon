//
//  CanvasConvertControl.hpp
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

#ifndef CanvasConvertControl_hpp
#define CanvasConvertControl_hpp

#include <stdio.h>

class CanvasConvertControl {
    
    
public:
    unsigned int createProgram(const char *vsSource, const char *fsSource);
    unsigned int createVAO(const float *vertices, const size_t verticesLength, const int *indices, const size_t indicesLength);
};

#endif /* CanvasConvertControl_hpp */
