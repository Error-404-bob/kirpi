import ../src/kirpi
import math

var shader:Shader
var texture:Texture
proc load() =
    shader=newShader("tests/resources/shaders/wind_effect.vs.glsl","tests/resources/shaders/wind_effect.fs.glsl")
    shader.setShaderValue("amount",50.0)
    texture=newTexture("tests/resources/sample.png")
    discard

proc update( dt:float) =
    
    shader.setShaderValue("time",getTime())
    discard
    

proc draw() =
    clear(Black)
    setShader(shader)
    draw(texture,100,200)
    #setShader()
    

#Run the game
run("Drawing Shapes",load,update,draw)