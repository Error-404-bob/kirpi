import ../src/kirpi

# Texture atlas containing animation frames
var zombie_atlas:Texture
# Sequence storing quads for each frame
var runAnim:seq[Quad]
# Current animation frame index
var animFrame:int=0
# Simple step counter for timing
var step=0


proc load() =
    # Load resources and build quad list
    zombie_atlas=newTexture("tests/resources/kenney_zombie_run.png")
    # Slice atlas horizontally into 96x128 quads
    for i in 0..<8 :
        runAnim.add( newQuad( i*96,0,96,128,zombie_atlas) )


proc update( dt:float) =
    # Advance animation every 10 updates
    if (step mod 10) == 0 :
        animFrame=if animFrame==runAnim.len-1 : 0 else : animFrame+1
        step=0
    step+=1

proc draw() =
    clear(Gray)

    # Show entire atlas on screen
    setColor( White )
    draw(zombie_atlas,0,0)

    #Current frame 
    var frame:Quad=runAnim[animFrame]

    # Highlight active frame bounds on the atlas
    setColor(Yellow)
    setLine(5)
    rectangle(DrawModes.Line,float(frame.x),float(frame.y),float(frame.w),float(frame.h) )

    # Draw selected frame at a given position
    setColor(White)
    draw(zombie_atlas,frame,350,270)

# Run the app
run("Using Quads",load,update,draw)
