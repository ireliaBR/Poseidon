//
//  CanvasRenderData.hpp
//  Poseidon
//
//  Created by fdd on 2024/2/2.
//

#ifndef CanvasRenderData_hpp
#define CanvasRenderData_hpp

#include <stdio.h>
#include "ElementRenderBuffer.hpp"

class CanvasRenderData {
public:
    static void createProgram(unsigned int &program,
                              const char *vsSource,
                              const char *fsSource);
    static unsigned int createProgram(const char *vsSource,
                              const char *fsSource);
    static void createShapeVAO(unsigned int &VAO,
                               unsigned int &VBO,
                               unsigned int &EBO,
                               const float *vertices,
                               const long verticesLength,
                               const int *indices,
                               const long indicesLength);
    static void createImageVAO(unsigned int &VAO, 
                               unsigned int &VBO1,
                               unsigned int &VBO2,
                               unsigned int &EBO,
                               const float *vertices,
                               const long verticesLength,
                               const int *indices,
                               const long indicesLength,
                               const float *texCoords,
                               const long texCoordsLength);
    static void createTexture(unsigned int &texture,
                              const void *data,
                              int width,
                              int height);
    static void releaseRenderBuffer(ElementRenderBuffer &renderBuffer);
};

#endif /* CanvasRenderData_hpp */
