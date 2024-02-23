//
//  ConvertElement.hpp
//  Poseidon
//
//  Created by fdd on 2024/1/30.
//

#ifndef ConvertElement_hpp
#define ConvertElement_hpp

#include <stdio.h>
#include <glm/gtc/matrix_transform.hpp>
#include "ElementRenderBuffer.hpp"

enum ElementType {
    Shape,
    Image,
};

class ConvertElement {
public:
    const char *identifier;
    glm::mat4 transform;
    glm::vec4 color;
    
    ElementType type;
    
    ElementRenderBuffer renderBuffer;
    unsigned int renderCount;
    
    float intensity;
    
};

#endif /* ConvertElement_hpp */
