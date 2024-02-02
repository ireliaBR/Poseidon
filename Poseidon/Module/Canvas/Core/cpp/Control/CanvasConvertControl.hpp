//
//  CanvasConvertControl.hpp
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

#ifndef CanvasConvertControl_hpp
#define CanvasConvertControl_hpp

#include <stdio.h>
#include "../Model/ConvertElement.hpp"
#include <array>

class CanvasConvertControl {
private:
    
    float screenWidth;
    float screenHeight;
    
    unsigned int FBO;
    unsigned int RBO;
    
public:
    CanvasConvertControl();
    unsigned int draw(const ConvertElement *array, size_t count);
    void configScreen(float screenWidth, float screenHeight);
    static unsigned int createProgram(const char *vsSource, const char *fsSource);
    static unsigned int createVAO(const float *vertices, const long verticesLength, const int *indices, const long indicesLength);
};

#endif /* CanvasConvertControl_hpp */
