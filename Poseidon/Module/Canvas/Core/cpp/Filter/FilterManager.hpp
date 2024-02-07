//
//  FilterManager.hpp
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

#ifndef FilterManager_hpp
#define FilterManager_hpp

#include <stdio.h>
#include <map>
#include "BaseFilter.hpp"

class FilterManager {
private:
    unsigned int VAO;
    unsigned int VBOs[2];
    unsigned int EBO;
    
    unsigned int FBO;
    
    float vertices[12] = {
        // positions
        1,  1, 0.0f, // top right
        1, -1, 0.0f, // bottom right
        -1, -1, 0.0f, // bottom left
        -1,  1, 0.0f  // top left
    };
    
    float texCoords[8] = {
        // texture coords
        1.0f, 1.0f, // top right
        1.0f, 0.0f, // bottom right
        0.0f, 0.0f, // bottom left
        0.0f, 1.0f  // top left
    };
    
    int indices[6] = {
        0, 1, 3, // first triangle
        1, 2, 3  // second triangle
    };
    
    std::map<const char *, unsigned int> programMap;
    
public:
    FilterManager();
    ~FilterManager();
    unsigned int filterChain(unsigned int texture, int width, int height, BaseFilter *filters, int filterCount);
    unsigned int filter(unsigned int texture, int width, int height, BaseFilter filter);
};

#endif /* FilterManager_hpp */
