//
//  CanvasRenderData.hpp
//  Poseidon
//
//  Created by fdd on 2024/2/2.
//

#ifndef CanvasRenderData_hpp
#define CanvasRenderData_hpp

#include <stdio.h>

class CanvasRenderData {
public:
    static unsigned int createProgram(const char *vsSource, 
                                      const char *fsSource);
    static unsigned int createShapeVAO(const float *vertices, 
                                       const long verticesLength,
                                       const int *indices,
                                       const long indicesLength);
    static unsigned int createImageVAO(const float *vertices, 
                                       const long verticesLength,
                                       const int *indices,
                                       const long indicesLength,
                                       const float *texCoords,
                                       const long texCoordsLength);
    static unsigned int createTexture(const void *data, 
                                      int width,
                                      int height);
};

#endif /* CanvasRenderData_hpp */
