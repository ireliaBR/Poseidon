//
//  BaseFilter.cpp
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

#include "BaseFilter.hpp"
#include "CanvasRenderData.hpp"

BaseFilter::BaseFilter(const char *vs, const char *fs) {
    this->vs = vs;
    this->fs = fs;
    
    CanvasRenderData::createProgram(program, this->vs, this->fs);
}

void BaseFilter::configUniform() {
}
