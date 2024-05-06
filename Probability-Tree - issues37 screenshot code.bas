
RANDOMIZE TIMER: scr& = _NEWIMAGE(1280, 720, 32): SCREEN scr&:
DIM amt AS INTEGER: amt = 337 ' amount of pixels/particles =)

TYPE Code
    x AS SINGLE ' particle x-pos
    y AS SINGLE ' particle y-pos
    s AS SINGLE ' particle speed
    v AS SINGLE
    d AS INTEGER '
    e AS INTEGER '
    f AS INTEGER '
    g AS INTEGER ' integers = node
    h AS INTEGER ' using several to
    i AS INTEGER ' force individual
    j AS INTEGER ' random behaviour
END TYPE

DIM SHARED code(1 TO amt) AS Code

FOR w = 1 TO amt
    code(w).x = 0
    code(w).y = 360
    code(w).s = (RND * .77 + .22)
    code(w).d = INT(RND * 2)
    code(w).e = INT(RND * 2)
    code(w).f = INT(RND * 2)
    code(w).g = INT(RND * 2)
    code(w).h = INT(RND * 2)
    code(w).i = INT(RND * 2)
    code(w).j = INT(RND * 2)
NEXT w

COLOR _RGB(44, 222, 255)

DO

    CLS

    FOR w = 1 TO amt

        ' low
        PSET (code(w).x - 1, code(w).y + 1)
        PSET (code(w).x + 0, code(w).y + 1)
        PSET (code(w).x + 1, code(w).y + 1)

        ' middle
        PSET (code(w).x - 1, code(w).y + 0)
        PSET (code(w).x + 0, code(w).y + 0)
        PSET (code(w).x + 1, code(w).y + 0)

        ' top
        PSET (code(w).x - 1, code(w).y - 1)
        PSET (code(w).x + 0, code(w).y - 1)
        PSET (code(w).x + 1, code(w).y - 1)

        code(w).x = code(w).x + code(w).s

        IF code(w).x > 100 THEN GOTO skipfirst

        IF code(w).x > 50 THEN 'first intersection
            IF code(w).d = 1 THEN code(w).y = code(w).y - code(w).s
            IF code(w).d = 0 THEN code(w).y = code(w).y + code(w).s
        END IF

        skipfirst:

        IF code(w).x > 150 THEN GOTO skipsecond ' skips previous

        IF code(w).x > 100 THEN 'second intersection.. etc etc
            IF code(w).e = 1 THEN code(w).y = code(w).y - code(w).s
            IF code(w).e = 0 THEN code(w).y = code(w).y + code(w).s
        END IF

        skipsecond: ' this is where it gets get intertwined = )

        IF code(w).x > 200 THEN GOTO skipthird

        IF code(w).x > 150 THEN
            IF code(w).f = 1 THEN code(w).y = code(w).y - code(w).s
            IF code(w).f = 0 THEN code(w).y = code(w).y + code(w).s
        END IF

        skipthird:

        IF code(w).x > 250 THEN GOTO skipfourth

        IF code(w).x > 200 THEN
            IF code(w).g = 1 THEN code(w).y = code(w).y - code(w).s
            IF code(w).g = 0 THEN code(w).y = code(w).y + code(w).s
        END IF

        skipfourth:

        IF code(w).x > 300 THEN GOTO skipfifth

        IF code(w).x > 250 THEN
            IF code(w).h = 1 THEN code(w).y = code(w).y - code(w).s
            IF code(w).h = 0 THEN code(w).y = code(w).y + code(w).s
        END IF

        skipfifth:

        IF code(w).x > 350 THEN GOTO skipsixth

        IF code(w).x > 300 THEN
            IF code(w).i = 1 THEN code(w).y = code(w).y - code(w).s
            IF code(w).i = 0 THEN code(w).y = code(w).y + code(w).s
        END IF

        skipsixth:

        IF code(w).x > 400 THEN GOTO fourevent

        IF code(w).x > 350 THEN
            IF code(w).j = 1 THEN code(w).y = code(w).y - code(w).s
            IF code(w).j = 0 THEN code(w).y = code(w).y + code(w).s
        END IF

        fourevent: ' fourevent = passed by x=400 at widht on screen

        ' at x > 400 plane out
        IF code(w).x > 400 THEN
            IF code(w).j = 1 THEN code(w).y = code(w).y
            IF code(w).j = 0 THEN code(w).y = code(w).y
        END IF ' only sideways movement from this point

        ' this moves particles back to left side
        IF code(w).x > 1280 THEN code(w).y = 360
        IF code(w).x > 1280 THEN code(w).x = 0

    NEXT w

    _LIMIT 60
    _DISPLAY

    IF INKEY$ <> "" THEN SYSTEM

LOOP
