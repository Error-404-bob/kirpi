import ../src/kirpi

type 
    Button = object 
        x:float
        y:float
        w:float
        h:float
        text:string
        toggled:bool=false

var buttons:seq[Button]

proc isContain(button:Button, x, y:float): bool =
    if x<button.x+button.width and x>button.x :
        if y<button.y+button.height and y>button.y :
            result=true
    result=false

proc load() =
    # center of the screen
    let wcx:float=window.getWidth().float*0.5
    let wcy:float=window.getHeight().float*0.5

    buttons.add( Button(x:wcx,y:wch-300,w:200.0,h:100.0,text:"Play Music" ) )
    buttons.add( Button(x:wcx,y:wch+100,w:200.0,h:100.0,text:"Play Sound" ) )
    

proc update( dt:float) =
    discard

proc draw() =
    clear(Gray)
    

    discard

# Run the app
run("Sounds",load,update,draw)
