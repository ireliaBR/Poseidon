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

class ConvertElement {
public:
    const char *identifier;
    glm::mat4 transform;
    glm::vec4 color;
    
    unsigned int VAO;
    unsigned int program;
    unsigned int renderCount;
    
};

#endif /* ConvertElement_hpp */
