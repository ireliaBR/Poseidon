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
};

#endif /* CanvasConvertControl_hpp */
