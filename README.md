# AirshipDodge
Final Project for ADV game dev

You can checkout this project in Browswer at this [itch link](https://legoguy32109.itch.io/airship-dodge) I can't get my player model to load in HTML5, so you're stuck with a cube ;(

![image](https://user-images.githubusercontent.com/37216503/165419301-62c5b833-3e83-46ef-8ce5-65815f39ae91.png)

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
