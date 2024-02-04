//
//  ElementRenderBuffer.cpp
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

#include "ElementRenderBuffer.hpp"
#include "CanvasRenderData.hpp"

ElementRenderBuffer::ElementRenderBuffer() {
    VAO = 0;
    VBOs = nullptr;
    VBOCount = 0;
    EBO = 0;
    program = 0;
    originTexture = 0;
    targetTexture = 0;
}
