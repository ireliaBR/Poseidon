//
//  ElementRenderBuffer.hpp
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

#ifndef ElementRenderBuffer_hpp
#define ElementRenderBuffer_hpp

#include <stdio.h>

class ElementRenderBuffer {
public:
    unsigned int VAO;
    unsigned int *VBOs;
    int VBOCount;
    unsigned int EBO;
    
    unsigned int program;
    unsigned int originTexture;
    unsigned int targetTexture;
    
    ElementRenderBuffer();
};

#endif /* ElementRenderBuffer_hpp */
