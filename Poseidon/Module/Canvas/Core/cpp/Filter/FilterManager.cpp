//
//  FilterManager.cpp
//  Poseidon
//
//  Created by fdd on 2024/2/4.
//

#include "FilterManager.hpp"
#include <OpenGLES/ES3/gl.h>
#include "CanvasRenderData.hpp"

FilterManager::FilterManager() {
    // FBO
    glGenFramebuffers(1, &FBO);
    
    // VAO
    glGenVertexArrays(1, &VAO);
    glGenBuffers(2, VBOs);
    glGenBuffers(1, &EBO);
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArray(VAO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBOs[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBOs[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(texCoords), texCoords, GL_STATIC_DRAW);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(1);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // note that this is allowed, the call to glVertexAttribPointer registered VBO as the vertex attribute's bound vertex buffer object so afterwards we can safely unbind
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // remember: do NOT unbind the EBO while a VAO is active as the bound element buffer object IS stored in the VAO; keep the EBO bound.
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    // You can unbind the VAO afterwards so other VAO calls won't accidentally modify this VAO, but this rarely happens. Modifying other
    // VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
    glBindVertexArray(0);
}

FilterManager::~FilterManager() {
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(2, VBOs);
    glDeleteBuffers(1, &EBO);
}

unsigned int FilterManager::filterChain(unsigned int texture, int width, int height, BaseFilter *filters, int filterCount) {
    CanvasRenderData::createImageVAO(VAO, VBOs[0], VBOs[1], EBO, vertices, sizeof(vertices), indices, sizeof(indices), texCoords, sizeof(texCoords));
    unsigned int previousTexture = texture;
    for (int i = 0; i < filterCount; i++) {
        unsigned int tmpTexture = filter(previousTexture, width, height, filters[i]);
        if (i != 0) {
            glDeleteTextures(1, &previousTexture);
        }
        previousTexture = tmpTexture;
    }
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(2, VBOs);
    glDeleteBuffers(1, &EBO);
    return previousTexture;
}

unsigned int FilterManager::filter(unsigned int texture, int width, int height, BaseFilter filter) {
    
//    if (filter.program == 0) {
//        if (programMap.count(filter.identify)) {
//            filter.program = programMap[filter.identify];
//        } else {
//            CanvasRenderData::createProgram(filter.program, filter.vs, filter.fs);
//            programMap[filter.identify] = filter.program;
//        }
//    }
    
    unsigned int tmpTexture;
    glGenTextures(1, &tmpTexture);
    glBindTexture(GL_TEXTURE_2D, tmpTexture);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    glBindTexture(GL_TEXTURE_2D, 0); // unbind
    
    // 配置 FBO[0] - Temp FrameBuffer
    glBindFramebuffer(GL_FRAMEBUFFER, FBO); // 使用 FBO[0]，下面的激活 & 绑定操作都会对应到这个 FrameBuffer
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, tmpTexture, 0);
    
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, width, height);
    
    glUseProgram(filter.program);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(glGetUniformLocation(filter.program, "intensity"), filter.filterValue);
    glBindVertexArray(VAO); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    glBindVertexArray(0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    return tmpTexture;
}
