import ../src/kirpi

var soundFX: Sound
var music: Sound

type 
    Button = object 
        name: string
        x, y, w, h: float
        text: string
        toggle: bool

var buttons: seq[Button]

proc isContain(button: Button, x, y: float): bool =
    # Basic rectangle hit test
    if x < button.x + button.w and x > button.x:
        if y < button.y + button.h and y > button.y:
            return true
    return false

proc load() =
    # Load a static sound (fully stored in memory)
    soundFX = newSound("tests/resources/sample_sound.mp3", SoundType.Static)

    # Load a streaming sound (decoded gradually)
    music   = newSound("tests/resources/music.mp3", SoundType.Stream)

    # Center of the screen
    let wcx = window.getWidth().float * 0.5
    let wcy = window.getHeight().float * 0.5

    # Simple UI buttons
    buttons.add(Button(name:"musicButton", x:wcx-100, y:wcy-55, w:200, h:100, text:"Play Music"))
    buttons.add(Button(name:"soundButton", x:wcx-100, y:wcy+55, w:200, h:100, text:"Play Sound"))

proc update(dt: float) =
    #Implementing basic button behaviour
    for i in 0..<buttons.len:
        if isMouseButtonPressed(MouseButton.Left):
            if buttons[i].isContain(getMouseX(), getMouseY()):

                # Toggle button state
                if buttons[i].toggle:
                    buttons[i].toggle = false

                    # Stop static or streaming sound depending on button
                    if buttons[i].name == "soundButton":
                        #Stop Sound
                        soundFX.stop()
                        buttons[i].text = "Play Sound"

                    if buttons[i].name == "musicButton":
                        #Stop Sound
                        music.stop()
                        buttons[i].text = "Play Music"

                else:
                    buttons[i].toggle = true

                    # Play static or streaming sound
                    if buttons[i].name == "soundButton":
                        #Play Sound
                        soundFX.play()
                        buttons[i].text = "Stop Sound"

                    if buttons[i].name == "musicButton":
                        #Play Sound
                        music.play()
                        buttons[i].text = "Stop Music"

        # Reset sound button when static sound ends
        if buttons[i].name == "soundButton" and buttons[i].toggle:
            if not soundFX.isPlaying():
                buttons[i].toggle = false
                buttons[i].text = "Play Sound"

proc draw() =
    clear(Gray)
    origin()

    # Basic UI rendering
    for i in 0..<buttons.len:
        if buttons[i].toggle:
            setColor(Yellow)
        else:
            setColor(Orange)

        rectangle(DrawModes.Fill, buttons[i].x, buttons[i].y, buttons[i].w, buttons[i].h, 16)

        setColor(Black)
        var buttonText = newText(buttons[i].text, getDefaultFont())
        var textSize   = buttonText.getSizeWith(24)
        var textX      = buttons[i].x + buttons[i].w*0.5 - textSize.x*0.5
        var textY      = buttons[i].y + buttons[i].h*0.5 - textSize.y*0.5
        draw(buttonText, textX, textY, 24)

# Run the app
run("Sounds", load, update, draw)
