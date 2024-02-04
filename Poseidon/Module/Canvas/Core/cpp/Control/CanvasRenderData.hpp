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
    static void createProgram(ElementRenderBuffer &renderBuffer,
                                      const char *vsSource,
                                      const char *fsSource);
    static void createShapeVAO(ElementRenderBuffer &renderBuffer,
                                       const float *vertices,
                                       const long verticesLength,
                                       const int *indices,
                                       const long indicesLength);
    static void createImageVAO(ElementRenderBuffer &renderBuffer,
                                       const float *vertices,
                                       const long verticesLength,
                                       const int *indices,
                                       const long indicesLength,
                                       const float *texCoords,
                                       const long texCoordsLength);
    static void createTexture(ElementRenderBuffer &renderBuffer,
                                      const void *data,
                                      int width,
                                      int height);
};

#endif /* CanvasRenderData_hpp */
