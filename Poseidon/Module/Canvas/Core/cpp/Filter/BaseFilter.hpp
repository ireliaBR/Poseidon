//
//  BaseFilter.hpp
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

#ifndef BaseFilter_hpp
#define BaseFilter_hpp

#include <stdio.h>

class BaseFilter {
private:
    const char *vs;
    const char *fs;
    
public:
    unsigned int program;
    BaseFilter();
    BaseFilter(const char *vs, const char *fs);
    void configUniform();
};

#endif /* BaseFilter_hpp */
