'use strict'


angular.module('webAppApp')
  .directive('doodlejump', ->
    templateUrl: 'views/directive/doodlejump.html'
    replace: true
    restrict: 'E'
    link: (scope, element, attrs) ->
        RNGrandom = ->
            return Math.random()

        #Platform class
        Platform = ->
             @width = 70
             @height = 17
             @x = RNGrandom()  * (width - @width)
             @y = position
             position += (height / platformCount)
             @flag = 0
             @state = 0

             #Sprite clipping
             @cx = 0
             @cy = 0
             @cwidth = 105
             @cheight = 31

             #Function to draw it
             @draw = ->
                  try
                       if @type is 1
                            @cy = 0
                       else if @type is 2
                            @cy = 61
                       else if @type is 3 and @flag is 0
                            @cy = 31
                       else if @type is 3 and @flag is 1
                            @cy = 1000
                       else if @type is 4 and @state is 0
                            @cy = 90
                       else @cy = 1000     if @type is 4 and @state is 1
                       ctx.drawImage image, @cx, @cy, @cwidth, @cheight, @x, @y, @width, @height
                  return


             #Platform types
             #1: Normal
             #2: Moving
             #3: Breakable (Go through)
             #4: Vanishable
             #Setting the probability of which type of platforms should be shown at what score
             if score >= 5000
                  @types = [2, 3, 3, 3, 4, 4, 4, 4]
             else if score >= 2000 and score < 5000
                  @types = [2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4]
             else if score >= 1000 and score < 2000
                  @types = [2, 2, 2, 3, 3, 3, 3, 3]
             else if score >= 500 and score < 1000
                  @types = [1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3]
             else if score >= 100 and score < 500
                  @types = [1, 1, 1, 1, 2, 2]
             else
                  @types = [1]
             @type = @types[Math.floor(RNGrandom()  * @types.length)]

             #We can't have two consecutive breakable platforms otherwise it will be impossible to reach another platform sometimes!
             if @type is 3 and broken < 1
                  broken++
             else if @type is 3 and broken >= 1
                  @type = 1
                  broken = 0
             @moved = 0
             @vx = 1
             return

        init = ->

             #Function for clearing canvas in each consecutive frame
             paintCanvas = ->
                  ctx.clearRect 0, 0, width, height
                  return

             #Player related calculations and functions
             playerCalc = ->
                  if dir is "left"
                       player.dir = "left"
                       player.dir = "left_land" if player.vy < -7 and player.vy > -15
                  else if dir is "right"
                       player.dir = "right"
                       player.dir = "right_land" if player.vy < -7 and player.vy > -15

                  #Adding keyboard controls
                  document.onkeydown = (e) ->
                       key = e.keyCode
                       if key is 37
                            dir = "left"
                            player.isMovingLeft = true
                       else if key is 39
                            dir = "right"
                            player.isMovingRight = true
                       if key is 32
                            if firstRun is true
                                 init()
                            else
                                 reset()

                  document.onkeyup = (e) ->
                       key = e.keyCode
                       if key is 37
                            dir = "left"
                            player.isMovingLeft = false
                       else if key is 39
                            dir = "right"
                            player.isMovingRight = false

                  #Accelerations produces when the user hold the keys
                  if player.isMovingLeft is true
                       player.x += player.vx
                       player.vx -= 0.15
                  else
                       player.x += player.vx
                       player.vx += 0.1     if player.vx < 0
                  if player.isMovingRight is true
                       player.x += player.vx
                       player.vx += 0.15
                  else
                       player.x += player.vx
                       player.vx -= 0.1     if player.vx > 0

                  # Speed limits!
                  if player.vx > 8
                       player.vx = 8
                  else player.vx = -8     if player.vx < -8

                  #console.log(player.vx);

                  #Jump the player when it hits the base
                  player.jump() if (player.y + player.height) > base.y and base.y < height

                  #Gameover if it hits the bottom
                  player.isDead = true if base.y > height and (player.y + player.height) > height and player.isDead isnt "lol"

                  #Make the player move through walls
                  if player.x > width
                       player.x = 0 - player.width
                  else player.x = width     if player.x < 0 - player.width

                  #Movement of player affected by gravity
                  if player.y >= (height / 2) - (player.height / 2)
                       player.y += player.vy
                       player.vy += gravity

                  #When the player reaches half height, move the platforms to create the illusion of scrolling and recreate the platforms that are out of viewport...
                  else
                       platforms.forEach (p, i) ->
                            p.y -= player.vy     if player.vy < 0
                            if p.y > height
                                 platforms[i] = new Platform()
                                 platforms[i].y = p.y - height
                            return

                       base.y -= player.vy
                       player.vy += gravity
                       if player.vy >= 0
                            player.y += player.vy
                            player.vy += gravity
                       score++

                  #Make the player jump when it collides with platforms
                  collides()
                  gameOver()     if player.isDead is true
                  return

             #Spring algorithms
             springCalc = ->
                  s = Spring
                  p = platforms[0]
                  if p.type is 1 or p.type is 2
                       s.x = p.x + p.width / 2 - s.width / 2
                       s.y = p.y - p.height - 10
                       s.state = 0     if s.y > height / 1.1
                       s.draw()
                  else
                       s.x = 0 - s.width
                       s.y = 0 - s.height
                  return

             #Platform's horizontal movement (and falling) algo
             platformCalc = ->
                  subs = platform_broken_substitute
                  platforms.forEach (p, i) ->
                       if p.type is 2
                            p.vx *= -1     if p.x < 0 or p.x + p.width > width
                            p.x += p.vx
                       if p.flag is 1 and subs.appearance is false and jumpCount is 0
                            subs.x = p.x
                            subs.y = p.y
                            subs.appearance = true
                            jumpCount++
                       p.draw()
                       return

                  if subs.appearance is true
                       subs.draw()
                       subs.y += 8
                  subs.appearance = false     if subs.y > height
                  return
             collides = ->

                  #Platforms
                  platforms.forEach (p, i) ->
                       if player.vy > 0 and p.state is 0 and (player.x + 15 < p.x + p.width) and (player.x + player.width - 15 > p.x) and (player.y + player.height > p.y) and (player.y + player.height < p.y + p.height)
                            if p.type is 3 and p.flag is 0
                                 p.flag = 1
                                 jumpCount = 0
                                 return
                            else if p.type is 4 and p.state is 0
                                 player.jump()
                                 p.state = 1
                            else if p.flag is 1
                                 return
                            else
                                 player.jump()
                       return


                  #Springs
                  s = Spring
                  if player.vy > 0 and (s.state is 0) and (player.x + 15 < s.x + s.width) and (player.x + player.width - 15 > s.x) and (player.y + player.height > s.y) and (player.y + player.height < s.y + s.height)
                       s.state = 1
                       player.jumpHigh()
                  return
             updateScore = ->
                  scoreText = document.getElementById("score")
                  scoreText.innerHTML = score
                  return
             gameOver = ->
                  platforms.forEach (p, i) ->
                       p.y -= 12
                       return

                  if player.y > height / 2 and flag is 0
                       player.y -= 8
                       player.vy = 0
                  else if player.y < height / 2
                       flag = 1
                  else if player.y + player.height > height
                       hideScore()
                       player.isDead = "lol"
                       console.log "finished"
                  return

             #Function to update everything
             update = ->
                  paintCanvas()
                  platformCalc()
                  springCalc()
                  playerCalc()
                  player.draw()
                  base.draw()
                  updateScore()
                  return
             dir = "left"
             jumpCount = 0
             firstRun = false

             animloop = ->
                  update()
                  requestAnimFrame animloop
                  return

             animloop()
             return
        reset = ->
             hideGoMenu()
             showScore()
             player.isDead = false
             flag = 0
             position = 0
             score = 0
             base = new Base()
             player = new Player()
             Spring = new spring()
             platform_broken_substitute = new Platform_broken_substitute()
             platforms = []
             i = 0

             while i < platformCount
                  platforms.push new Platform()
                  i++
             return

        #Show ScoreBoard
        showScore = ->
             menu = document.getElementById("scoreBoard")
             menu.style.zIndex = 1
             return

        #Hide ScoreBoard
        hideScore = ->
             menu = document.getElementById("scoreBoard")
             menu.style.zIndex = -1
             return
        playerJump = ->
             player.y += player.vy
             player.vy += gravity
             player.jump()     if player.vy > 0 and (player.x + 15 < 260) and (player.x + player.width - 15 > 155) and (player.y + player.height > 475) and (player.y + player.height < 500)
             if dir is "left"
                  player.dir = "left"
                  player.dir = "left_land"     if player.vy < -7 and player.vy > -15
             else if dir is "right"
                  player.dir = "right"
                  player.dir = "right_land"     if player.vy < -7 and player.vy > -15

             #Adding keyboard controls
             document.onkeydown = (e) ->
                  key = e.keyCode
                  if key is 37
                       dir = "left"
                       player.isMovingLeft = true
                  else if key is 39
                       dir = "right"
                       player.isMovingRight = true
                  if key is 32
                       if firstRun is true
                            init()
                            firstRun = false
                       else
                            reset()
                  return

             document.onkeyup = (e) ->
                  key = e.keyCode
                  if key is 37
                       dir = "left"
                       player.isMovingLeft = false
                  else if key is 39
                       dir = "right"
                       player.isMovingRight = false
                  return


             #Accelerations produces when the user hold the keys
             if player.isMovingLeft is true
                  player.x += player.vx
                  player.vx -= 0.15
             else
                  player.x += player.vx
                  player.vx += 0.1     if player.vx < 0
             if player.isMovingRight is true
                  player.x += player.vx
                  player.vx += 0.15
             else
                  player.x += player.vx
                  player.vx -= 0.1     if player.vx > 0

             #Jump the player when it hits the base
             player.jump()     if (player.y + player.height) > base.y and base.y < height

             #Make the player move through walls
             if player.x > width
                  player.x = 0 - player.width
             else player.x = width     if player.x < 0 - player.width
             player.draw()
             return
        update = ->
             ctx.clearRect 0, 0, width, height
             playerJump()
             return
        window.requestAnimFrame = (->
             window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
                  window.setTimeout callback, 1000 / 60
                  return
        )()
        canvas = element.find('canvas')[0]
        console.log canvas
        ctx = canvas.getContext("2d")
        width = 422
        height = 552
        canvas.width = width
        canvas.height = height
        platforms = []
        image = element.find(".sprite")[0]
        player = undefined
        platformCount = 10
        position = 0
        gravity = 0.2
        animloop = undefined
        flag = 0
        menuloop = undefined
        broken = 0
        dir = undefined
        score = 0
        firstRun = true
        Base = ->
             @height = 5
             @width = width
             @cx = 0
             @cy = 614
             @cwidth = 100
             @cheight = 5
             @moved = 0
             @x = 0
             @y = height - @height
             @draw = ->
                  try
                       ctx.drawImage image, @cx, @cy, @cwidth, @cheight, @x, @y, @width, @height
                  return

             return

        base = new Base()
        Player = ->
             @vy = 11
             @vx = 0
             @isMovingLeft = false
             @isMovingRight = false
             @isDead = false
             @width = 55
             @height = 40
             @cx = 0
             @cy = 0
             @cwidth = 110
             @cheight = 80
             @dir = "left"
             @x = width / 2 - @width / 2
             @y = height
             @draw = ->
                  try
                       if @dir is "right"
                            @cy = 121
                       else if @dir is "left"
                            @cy = 201
                       else if @dir is "right_land"
                            @cy = 289
                       else @cy = 371     if @dir is "left_land"
                       ctx.drawImage image, @cx, @cy, @cwidth, @cheight, @x, @y, @width, @height
                  return

             @jump = ->
                  @vy = -8
                  return

             @jumpHigh = ->
                  @vy = -16
                  return

             return

        player = new Player()
        i = 0

        while i < platformCount
             platforms.push new Platform()
             i++
        Platform_broken_substitute = ->
             @height = 30
             @width = 70
             @x = 0
             @y = 0
             @cx = 0
             @cy = 554
             @cwidth = 105
             @cheight = 60
             @appearance = false
             @draw = ->
                  try
                       if @appearance is true
                            ctx.drawImage image, @cx, @cy, @cwidth, @cheight, @x, @y, @width, @height
                       else
                            return
                  return

             return

        platform_broken_substitute = new Platform_broken_substitute()
        spring = ->
             @x = 0
             @y = 0
             @width = 26
             @height = 30
             @cx = 0
             @cy = 0
             @cwidth = 45
             @cheight = 53
             @state = 0
             @draw = ->
                  try
                       if @state is 0
                            @cy = 445
                       else @cy = 501     if @state is 1
                       ctx.drawImage image, @cx, @cy, @cwidth, @cheight, @x, @y, @width, @height
                  return

             return

        Spring = new spring()
        menuLoop = ->
             update()
             requestAnimFrame menuLoop
             return

        init()
        console.log "doodle jump"
  )
