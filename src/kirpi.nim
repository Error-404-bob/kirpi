# Raylib

import tables
import raylib as rl

import graphics, inputs, sound

type 
  AppSettings* = object
    width*:int=640
    height*:int=480
    fps*:int=60
    flags*:Flags[ConfigFlags]=flags(Msaa4xHint, WindowHighdpi)
  App* = object
    load: proc() 
    draw: proc()  
    update: proc(dt:float) 
  AppWindow* = object #A Wrapper solution for raylib issues about closing window time
  

var kirpiApp*:App=App()
var appWindow:AppWindow




proc `=destroy`(app:var AppWindow) =
  assert isWindowReady(), "Window is already closed!"
  closeAudioDevice()
  closeWindow()




proc `=sink`(x: var AppWindow; y: AppWindow) {.error.}
proc `=dup`(y: AppWindow): AppWindow {.error.}
proc `=copy`(x: var AppWindow; y: AppWindow) {.error.}
proc `=wasMoved`(x: var AppWindow) {.error.}

proc initAppWindow(title:string,appSettings:AppSettings) =
  assert not isWindowReady(), "Window is already opened"
  setConfigFlags(appSettings.flags)
  initWindow( int32(appSettings.width), int32(appSettings.height), title)
  setTargetFPS(int32(appSettings.fps))
  initAudioDevice()
  kirpiApp.load() # load 


var fpsTimer = 0.0
proc run*(title:string,load: proc(), update: proc(dt:float), draw: proc(), settings:AppSettings=AppSettings()) =
  kirpiApp.load = load
  kirpiApp.update = update
  kirpiApp.draw = draw
  initAppWindow(title,settings)

  while not windowShouldClose() :
    #Update Sound Streams
    for id in soundStreamSources.keys:
      rl.updateMusicStream(soundStreamSources[id])
        

    kirpiApp.update(1.0) # update 

    beginDrawing()
    kirpiApp.draw() # draw
    endDrawing()

    let dt = 1.0 / 60.0
    fpsTimer += dt
    if fpsTimer >= 1.0:
      echo "FPS: " & $(getFrameTime() * 1000.0) & " ms"
      fpsTimer = 0.0
    


export graphics, inputs
export sound 