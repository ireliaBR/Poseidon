//
//  CanvasConvertControl.cpp
//  Poseidon
//
//  Created by fdd on 2024/1/23.
//

#include "CanvasConvertControl.hpp"
#include <OpenGLES/ES3/gl.h>
#include <iostream>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

CanvasConvertControl::CanvasConvertControl() {
    // 创建 Render Buffer Object
    glGenRenderbuffers(1, &RBO);
    glBindRenderbuffer(GL_RENDERBUFFER, RBO);
    
    // 创建 Frame Buffer Object
    glGenFramebuffers(1, &FBO);
    glBindFramebuffer(GL_FRAMEBUFFER, FBO);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, RBO);
}

void CanvasConvertControl::configScreen(float screenWidth, float screenHeight) {
    this->screenWidth = screenWidth;
    this->screenHeight = screenHeight;
}

unsigned int CanvasConvertControl::draw(const ConvertElement *array, size_t count) {
    
    glBindFramebuffer(GL_FRAMEBUFFER, FBO);
    glViewport(0, 0, screenWidth, screenHeight);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // draw our first triangle
    glm::mat4 projection = glm::ortho(0.0f, static_cast<float>(screenWidth), 0.0f, static_cast<float>(screenHeight));
    
    //    glm::mat4 model = glm::mat4(1.0f);
    //    model = glm::translate(model, glm::vec3(0, 0, 0));
    //    model = glm::scale(model, glm::vec3(1242, 1242, 1));
    //    model = glm::scale(model, glm::vec3(1.0f, screenWidth / screenHeight, 1.0f));
    for (int i = 0; i < count; i++) {
        ConvertElement element = array[i];
        element.transform[3][1] = screenHeight - element.transform[3][1];
        
        glUseProgram(element.program);
        glUniformMatrix4fv(glGetUniformLocation(element.program, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
        glUniformMatrix4fv(glGetUniformLocation(element.program, "model"), 1, GL_FALSE, glm::value_ptr(element.transform));
        switch (element.type) {
            case Shape:
                glUniform4fv(glGetUniformLocation(element.program, "color"), 1, glm::value_ptr(element.color));
                break;
            case Image:
                glUniform1i(glGetUniformLocation(element.program, "texture1"), 0);
                glActiveTexture(GL_TEXTURE0);
                glBindTexture(GL_TEXTURE_2D, element.texture);
                break;
            default:
                break;
        }
        
        glBindVertexArray(element.VAO); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
        glDrawElements(GL_TRIANGLES, element.renderCount, GL_UNSIGNED_INT, 0);
    }
    return RBO;
}
