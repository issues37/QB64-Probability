'  RESEED THE RANDOMIZER SO THE ANIMATION IS DIFFERENT
'  EVERYTIME IT IS EXECUTED
Randomize Timer

'  DEFINE THE KEY CODES WE WANT TO USE
Const KeyESC = 27

'  SINCE THE WINDOW IS NOT RESIZEABLE, DEFINE THE WINDOW
'  SIZE AS A CONSTANT
Const WinWidth = 1920 / 2 '800
Const WinHeight = 1080 / 2 '600

'  STARTX SHOULD BE SET OFF SCREEN ON THE LEFT SIDE OF THE
'  SCREEN SO THE "CARS" APPEAR TO DRIVE INTO THE SCREEN.
'  STARTX SHOULD BE A NEGATIVE NUMBER
Const StartX = -10
'  FOR THE BEST VISUAL, THE STARTING Y SHOULD BE HALF OF
'  THE SCREEN HEIGHT
Const StartY = WinHeight / 2

'  THE CAR STRUCTURE STORES ALL THE ASSOCIATED DATA FOR EACH
'  CAR.
'  X = CURRENT X-COORDINATE
'  Y = CURRENT Y-COORDINATE
'  YDIRECTION = 1 FOR LEFT, 0 FOR STRAIGHT, AND -1 FOR RIGHT
'  CARCOLOR = THE COLOR OF THE CURRENT CAR
'  CARATRAILCOLOR = THE COLOR OF THE TRAIL MADE BY THE CAR
Type Car
    X As Integer
    Y As Integer
    YDirection As Integer
    CarColor As _Unsigned Long
    CarTrailColor As _Unsigned Long
End Type

'  WINDOWIMAGE = THE IMAGE USED FOR THE WINDOW ITSELF
'  BACKIMAGE = A BACKBUFFER IMAGE USED TO DRAW THE CAR TRAILS
Dim WindowImage As Long
Dim BackImage As Long

'  INTERSECTIONPXDISTANCE = IS THE DISTANCE IN PIXELS (ON THE
'                           X-AXIS) BETWEEN EACH INTERSECTION
Dim IntersectionPxDistance As _Unsigned Integer
'  PIXELDISTANCEBETWEENCARS = IS THE DISTANCE IN PIXELS (ON THE
'       X-AXIS) BETWEEN THE BACK OF ONE CAR TO THE FRONT OF THE
'       THE CAR BEHIND IT
Dim PixelDistanceBetweenCars As _Unsigned Integer
'  CURRENTCARX = IS ONLY USED IN SETTING UP THE CARS
Dim CurrentCarX As Integer
'  STARTCHANGEOFDIRECTION = IS THE DISTANCE FROM THE LEFT SIDE
'  OF THE SCREEN TO THE FIRST INTERSECTION
Dim StartChangeOfDirection As Integer
'  NUMBEROFCARS = THE TOTAL AMOUNT OF CARS IN TOTAL.
Dim NumberOfCars As Integer


CurrentCarX = StartX
StartChangeOfDirection = 40

IntersectionPxDistance = 20
PixelDistanceBetweenCars = 10

'  NUMBEROFCARS = (960 + ABS(-10 * 2)) / 10
NumberOfCars = (WinWidth + Abs(StartX * 2)) / PixelDistanceBetweenCars

Dim Shared Cars(NumberOfCars) As Car

'  DARKER = HOW MUCH DARKER THE COLOR OF THE TRAIL IS COMPARED TO THE CAR.
Const Darker = 0 '80

For i = 0 To NumberOfCars - 1

    Dim Red As _Unsigned _Byte
    Dim Green As _Unsigned _Byte
    Dim Blue As _Unsigned _Byte

    Red = Rnd * 128 + 127
    Green = Rnd * 128 + 127
    Blue = Rnd * 128 + 127

    Cars(i).X = CurrentCarX
    Cars(i).Y = StartY
    Cars(i).YDirection = 0
    Cars(i).CarColor = _RGB32(Red, Green, Blue)
    Cars(i).CarTrailColor = _RGB32(Red - Darker, Green - Darker, Blue - Darker)

    CurrentCarX = CurrentCarX - PixelDistanceBetweenCars
Next


'  CREATE AN IMAGE FOR THE WINDOW
WindowImage = _NewImage(WinWidth, WinHeight, 32)
'  CREATE THE APP WINDOW AND USE THE WINDOWIMAGE IMAGE
Screen WindowImage
'  SET THE TITLE OF THE APP
_Title "Probability Tree Demo Ver 1 - By TJP"

'  CREATE THE BACK BUFFER IMAGE FOR THE CAR TRAILS
BackImage = _NewImage(WinWidth, WinHeight, 32)
'  TELL THE APP TO DRAW BACK BUFFER IMAGE
_Dest BackImage
'  CLEAR THE BACK BUFFER IMAGE
Cls


'  START A DO LOOP (ALSO KNOWN AS A "GAME LOOP") TO CREATE AND MAINTAIN
'  THE ANIMATION
Do

    '  SET A LIMIT TO THE NUMBER OF FRAMES PER SECOND. IF YOU REM THIS
    '  OUT OR REMOVE IT, THE ANIMATION COULD RUN EXTREMELY FAST.

    _Limit 60

    '  SET THE DRAWING DESTINATION TO THE BACK BUFFER IMAGE
    _Dest BackImage

    '  DRAW A SEMI-TRANSPARENT BOX COVERING THE BACK BUFFER TO FADE THE
    '  CAR TRAILS OUT
    Line (0, 0)-(WinWidth, WinHeight), _RGBA32(0, 0, 0, 6), BF

    '  SET THE DRAWING DESTINATION TO THE MAIN WINDOW
    _Dest WindowImage
    '  DRAW THE BACK BUFFER (CAR TRAILS) IMAGE ON TO THE WINDOW IMAGE
    _PutImage , BackImage, WindowImage


    For DrawMultipleTimes = 0 To 1
        For itCar = 0 To NumberOfCars - 1

            '  THE MORE YOU CALL THE RND FUNCTION, THE MORE IT RECALCULATES AND RESEEDS
            Dim TRND As Double
            TRND = Rnd

            '  SET THE DRAWING DESTINATION TO THE WINDOW IMAGE AND DRAW A CAR
            _Dest WindowImage
            Line (Cars(itCar).X - 5, Cars(itCar).Y - 5)-(Cars(itCar).X + 5, Cars(itCar).Y + 5), _RGB32(0, 0, 0), BF
            Line (Cars(itCar).X - 3, Cars(itCar).Y - 3)-(Cars(itCar).X + 3, Cars(itCar).Y + 3), Cars(itCar).CarColor, BF

            '  SET THE DRAWING DESTINATION TO THE BACK BUFFER IMAGE AND DRAW THE CURRENT CAR TRAIL PART
            _Dest BackImage
            Line (Cars(itCar).X - 1, Cars(itCar).Y - 1)-(Cars(itCar).X + 1, Cars(itCar).Y + 1), Cars(itCar).CarTrailColor, BF

            Dim InDrawingArea As Integer
            InDrawingArea = Abs(Cars(itCar).X < (WinWidth + Abs(StartX)))

            Dim NotInDrawingArea As Integer
            NotInDrawingArea = Abs(InDrawingArea = 0)

            Dim IncrementCarX As Integer
            IncrementCarX = Cars(itCar).X + 1

            Cars(itCar).X = IncrementCarX * InDrawingArea + StartX * NotInDrawingArea


            '  SIMPLY ADD THE YDIRECTION TO THE CURRENT CAR'S Y-COORDINATE
            Cars(itCar).Y = Cars(itCar).Y + Cars(itCar).YDirection
            '  THIS LINE BASICALLY STATES THAT IF THE CURRENT CAR'S COORDINATE IS GREATER OR EQUAL TO THE
            '  STARTING POINT WHERE IT CAN START TO CHANGE DIRECTIONS, THEN ALLOW THE CAR TO MOVE IN THE
            '  CURRENT Y-DIRECTION. IF NOT, THE CAR NEEDS TO BE ON THE Y-POSITION OF THE STARTING GATE.

            Dim InStartZone As Integer
            InStartZone = Abs(Cars(itCar).X < StartChangeOfDirection)

            Dim NotInStartZone As Integer
            NotInStartZone = Abs(InStartZone = 0)


            Cars(itCar).Y = Cars(itCar).Y * NotInStartZone + StartY * InStartZone

            If Abs(Cars(itCar).X >= StartChangeOfDirection) And Abs(((Cars(itCar).X - StartChangeOfDirection) Mod IntersectionPxDistance) = 0) Then

                '  DECIDE TO GO LEFT, RIGHT, OR STRAIGHT
                '  GET A RANDOM NUMBER AND SEE IF IT IS LESS THAN 0.5. SINCE TRUE IS -1 IN QB64, WE NEED TO
                '  GET THE ABSOLUTE VALUE OF THE RESULT TO GET A POSITIVE 1 IF IT IS TRUE. WE MULTIPLE THE
                '  RESULT BY 2. IF THAT VALUE IS 2, THEN WE SUBTRACT IT FROM 1 TO GET A -1. IF THE VALUE IS
                '  ZERO, THEN WE GET A POSITIVE 1. WE THEN MULTIPLE THAT BY THE ABSOLUTE VALUE OF THE BOOLEAN
                '  RESULT. IF IT IS TRUE, THEN THE TOTAL VALUE WILL EITHER BE A 1 OR -1, FOR LEFT OR RIGHT
                '  RESPECTIVELY. IF THE LAST CONDITION IS FALSE, THEN THE TOTAL VALUE WILL BE 0 FOR STRAIGHT.
                Cars(itCar).YDirection = (1 - (2 * Abs(Rnd < 0.5))) * Abs(Rnd > 0.35)
            End If

        Next
    Next

    '  SET THE DRAWING DESTINATION TO THE WINDOW IMAGE SO WE CAN DRAW THE LINES ON IT
    _Dest WindowImage

    '  DRAW VERTICAL LINES AT EACH INTERSECTION
    For x = StartChangeOfDirection To WinWidth Step IntersectionPxDistance
        Line (x, 0)-(x, WinHeight), _RGBA32(100, 100, 100, 255)
    Next

    '  TELL THE APP TO RENDER THE FINAL DRAWING TO THE SCREEN AND DISPLAY IT
    _Display

Loop While _KeyHit <> KeyESC

System


