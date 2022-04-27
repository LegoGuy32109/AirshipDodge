# AirshipDodge Documentation
Final Project for ADV game dev

You can checkout this project in your browser at this [itch link](https://legoguy32109.itch.io/airship-dodge) I can't get my player model to load in HTML5, so you're stuck with a cube ;(

![image](https://user-images.githubusercontent.com/37216503/165421563-f633f2ee-de64-4123-bf41-fc2b5a7549b1.png)

## This Repo Contains
* The blender and .glb files for the custom models in this game
* The Godot project in full, with all resources/materials 
* A Third-Person Platformer with robust BOOST mechanics

## BOOST Mechanics?
That's right, looking in the `Scripts/Player.gd` file will illuminate the boost, or slide mechanic I implemented for this game. First by default the player is controlled by WASD controls, that affect a velocity vector that is passed into the `move_and_slide()` function within godot. This moves the Kinematic Player around the scene in a normal PC game fashion. 

However, to make the movement more enjoyable, the player will increase their speed after moving for a while. The script keeps track of how long the player is pushing a movement key and will increase the speed until they release it. This makes traveling in one direction less annoying. However, if the code only did that the player would accelerate to infinity. To prevent this I implemented **movement dampening** which will lower the velocity vector by a quotient of the current velocity in that axis by a dampeing factor. It's easier to explain if I show you:
```
# movement dampening
	var dampFactor = 10
	if sliding:
		dampFactor = 30
	
	if abs(velocity.x) > 0:
		velocity.x -= velocity.x/dampFactor
		if abs(velocity.x) < .07:
			velocity.x = 0
	if abs(velocity.z) > 0:
		velocity.z -= velocity.z/dampFactor
		if abs(velocity.z) < .07:
			velocity.z = 0
```
So if the character is moving, then a dampening effect is applied, but it becomes greater as the velocity increases until it stalls at a maximum speed. When no movement is applied to the player, then it slows down and comes to a stop on the floor. In some situations the player would wobble back and forth as the dampening was pushing it past 0, so I checked if it was below a certain threshold and set it to be 0. How ever you'll notice that the dampening factor is increased to lower this effect when sliding, which finally gives me the opportunity to talk about

![image](https://user-images.githubusercontent.com/37216503/165420719-c9b08f6c-cf96-4c86-9151-631f9181f27e.png)

**THE BOOST!**
This game is crafted around the gameplay of charging a boost meter by holding space in the air. The spacebar doubles as the jump button so it's lowering the amount of controls but increasing the complexity, which I love.

To accomplish this, luckliy Godot has a `is_on_floor()` function so it's easy to check if the player is in the air, and has the spacebar pressed. This will charge up the BOOST meeter in the top left of the player's screen, which depeletes as they boost forward on the ground.

The boost accelerates the player very quickly, so it's wise to charge only some of the boost meter when in the air to not rush off a platform and die. This adds more complexity to the gameplay, and when combined with ramps and jumping off during a boost gives a very exciting and enjoyable system.

## Shape Keys
To make the game more exciting and dynamic, the player model will react with shape keys as you're jumping and boosting. A shape key is a set of verticies that are different from a default position. 

| Default Position | Midair Shape Key | Boosting Shape Key |
|------------------|------------------|--------------------|
|![image](https://user-images.githubusercontent.com/37216503/165426243-2d3da5fa-80bf-4511-82a7-94a6106228f1.png)|![image](https://user-images.githubusercontent.com/37216503/165426261-5122f45f-c33e-4c12-9429-cdf8b6f9da4b.png)|![image](https://user-images.githubusercontent.com/37216503/165426287-c2e2f46b-64c3-4d1b-8dcc-46b48c827020.png)|

The weight of a shape key is dependant on a weight, a decimal between 0 and 1. Godot doesn't enforce limits to shape keys, so you can influence your model to have a negative weight or a super high weight value. The verticies in the model will linearly transition from the idle state to the new shape key state as the weight for that key increases. You can even apply multiple shape key states at once with their weights, so the player model can be jumping and boosting at the same time.

Shape Keys were my preferred method of animating the character, as I envisioned the appearance of the character dependant on states, and I would transtion from state to state as the game continued. Compared to an armature animation model, where the character would be constantly moving or in certain looping animations switching between them. Shape keys were a lot easier to implement, because instead of using an animation controller in Godot I just had to modify the shape key values, between 0 and 1. I was really excited with the results I could get in the game, so I encourage you to download the files here and try them on your computer. They aren't working in HTML5 ;(

## The Player Model
I just wanted to mention the player model is a kind of hard-modeling style. To accomplish this in blender, it's recommended to use subtle bevels to make a model look like a realistic hard surface object. I don't have a very realistic model, but I was impressed with the smooth finish I was able to create. 

In blender if you select your objcet and `Shade Smooth`, the sharp edges will make the model look strange, but if you go to the *Object Data Properties* panel and check `Auto Smooth` this turns the model into a very smooth, yet well defined model. It smoothes the edges that are less than a certain angle, the default is 30 degrees. I changed this value to 20.6 degrees to get a good finish on the front areodynamic curves of the player robot, but maintianing the definition of it's fins in the back.

## Speedrunning Timer
To really get the game exciting, I have a timer UI element in the top left of the screen that keeps track of the time it takes the player to complete the level. 

![image](https://user-images.githubusercontent.com/37216503/165428643-a7e59ce2-a252-48c4-9ef7-4d34dbd17bf3.png)

I keep track of time by just adding the `delta` variable in the `_process()` function when the player hits the first checkpoint, and ending it when the player reaches the last one. I was able to format the timer in minutes:seconds:milliseconds thanks to this useful code from [John's Godot blog](https://gamedevbeginner.com/how-to-make-a-timer-in-godot-count-up-down-in-minutes-seconds/#stopwatch). The code that worked for me was 

`timeString = "%02d:%02d:%02d" % [totalTime / 60, fmod(totalTime, 60), fmod(totalTime, 1) * 100]`

I then update the Label displaying the time with `timeString` each frame to give an accurate speedrunning clock. This encourages players to master the controls and try to complete the level as fast as possible. You can also retry the level whenever you want with the **R** key.

## Checkpoints
Mentioning the timer reminded me about the checkpoints I designed. 

![image](https://user-images.githubusercontent.com/37216503/165429340-987351fd-2114-4009-96be-29d1f4b51179.png)

The checkpoints are transparent spheres that have a small particle affect applied to them. I indicate the next checkpoint the player is supposed to hit with a green material. The checkpoints all by default have a green material, but I override them with a blue material thanks to Godot's cool **Material Override** attribute for meshes. When a checkpoint becomes the next checkpoint the player needs to hit, I just set the `$MeshInstance.material_override = null`, you can see it in action in the `Scripts/Checkpoint.gd` script. In that script I also contain the logic to make sure the player completes the checkpoints in the right order. The checkpoints are all children of an empty and are labeled like this:

![image](https://user-images.githubusercontent.com/37216503/165429796-481ccf6e-1936-4777-bcd6-db87f4de6c18.png)

The numbering actually isn't important, their index under their parent is. The checkpoint at index [0] is set to be the first one the player has to hit, a green checkpoint. When the player does hit it, and it can only hit the active checkpoint, the checkpoint `queue_free()`'s itself and removes itself from the scene. That means the next checkpoint is now index [0] and the cycle continues until the Checkpoints parent doesn't have any children. Then the player has beat the level, and it will load the next level in 2 seconds.

## Levels, and other Input Controls
The levels consist of a scene saved like `Level1.tscn, Level2.tscn... ` when the player completes the level hitting all the checkpoints in the right order, it takes the number of the current level by substringing the name of the parent node. Then adds 1 to it and loads the next level. I manually check when the player has reached the last level, and set the next level to be loaded Level1 so the game loops.

The mouse contols are simply moving the mouse along the y axis, and recording that movement to rotate the player around the scene. To accomplish this however, I need to make sure the mouse cursor is captured so that it doesn't leave the window for a 180 turn. I can accompish this by setting the mouse mode to `MOUSE_MODE_CAPTURED`, however now the player can't close the window or do anything else with the mouse since it's captured. So I then programmed that when the esc key was pressed, the mouse mode was now `MOUSE_MODE_VISIBLE`, so it could leave the game window. Now when the player wants to return to their cursor captured by the mouse, they can just click within the game and the mode goes back to captured. This is a standard control sceme for most PC applications, so I assumed the player would instinctively attempt these controls to get the desired result.

That's about all the unique stuff I did for this game, I hope it showcased my knowledge of the engine and was a project at a 400 level. Thanks for reading!
