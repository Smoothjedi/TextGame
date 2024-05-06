# TextGame
A text game where you need to find your keys to get inside before you die of dehydration

## Overview:
Waking up outside on your deck after a party the previous night, you realize you are extremely dehydrated after sleeping in the sun all morning. The goal is to get back inside to relax and recuperate! 

## Locations:
1. **Your deck**: You woke up here without your shoes. The beginning, and potentially end, of your adventure, but, unfortunately, the back door is a sliding one and the bar is down.
2. **Your front yard**: Severely damaged area, except the front door to your house. That's working fine, and it's locked.
3. **Your side yard**: Who uses the side yard anyways? You certainly don't, and it shows. Contains lots of overgrown foilage, and since apparently no one decided to use the trashcan, broken bottles litter the ground. Not safe to search without shoes and gloves.
4. **Your backyard**: A depressingly small space that shows off your lack of a green thumb. It's become a mudpit, potentially concealing something important.
## Inventory items:
1. Your **left shoe**: Not immediately obvious where exactly this went; a good place to search may be the backyard.
2. Your **right shoe**: You have a faint recollection of possibly losing this in the front yard.
3. Your **work gloves**: You usually keep these hanging up over your deck for miscellaneous projects.
4. Your **house key**: It's anyone's guess where this went, which is disappointing since that's what you are missing to get inside. Might be worth checking the side yard, but it's treacherous over there.
## Goal state:
1. Well, you could kick the front door down, but you've already got enough damage to your yard and house to not make that economically feasible. Plus, your strength is waning from being dehydrated. Find your house key so you can get to the front yard and subsequently inside before you succumb to the elements!
2. You're sick from dehydration, and it's wearing on you. Your clock is ticking, and if you're not able to get inside in 12 actions (search, move, item manipulation), you're done for.
## Sources used:
ChatGPT 3.5, my previous assignments, looked at the stateful game given as an example, but did not use it
## Optional Features:
1. **Time Limit**: The game has a twelve action limit. You just don't have enough endurance to make it any further. The minimum to complete the game, if I counted correctly, is 8 actions. At the beginning of each turn, your status can escalate in severity until the game ends.
2. **Multiple endings**: Everyone would love to get back in their house and have an enjoyable day, which is one of the endings, however, if you take too long it's quite possible you'll never make it back inside.
3. **Variable descriptions**: The first time you're in an area, and if you request for a description of the area in the menu, you'll get the full description. Subsequent turns through the menu at those locations will give a shorter description.

### ChatGPT prompts:
1. "I've got a Racket program that uses mutable data to make an adventure game. The mutable data is for tracking the state. I have an inventory to manage, and location between four destinations. I need to change this to use non mutable data. To start, can you recommend a state object I can pass around and a method to send me back a new state should it need to change?"
2. "There is a chance there are items at different locations that the player can pick up and get added to inventory. Once added to inventory, it would no longer be at the location. How would you change the locations to be able to handle this?"
3. "Remove-item seems to be giving me an error here. I get this: application: not a procedure; expected a procedure that can be applied to arguments given: 'key. Specifically, it highlighted the equal? statement."
4. "Can you give me a function that will display all the values of the state?"
5. "Ok, let's add a new action that looks at the current location and displays items available to pick up."
6. "I got an error when trying to display items with the for-each. Can we export that to a function as I think I'll want to reuse it?"
7. "Can we add an option to quit?"
8. "Can we change quit to 9? I'd like it to be at the end of the list of future options."
9. "The display function works because I changed the display-state function to use it. However, the choice of 2 is failing. I get this error: item-name: contract violation. Can you help me with this?"
10. "Neither of these options are what I'm looking for."
11. "Location is a struct."
12. "All right, that seems to work. Now I've got a problem when I try to pick up an item. It looks like when I type 'key', it is sending a string to compare rather than the symbolic value of key."
13. "It is using the symbol correctly, however it still can't find it because it appears that it's trying to compare the symbol to the struct itself, rather than the name in the item struct."
14. "This won't compile. I'm getting the error any: use of 'any' outside the range of an arrow contract."
15. "Sorry this isn't working. Let's back up with something similar. Can you give me a function that will filter a list of items with a particular name?"
16. "The any command was not in racket/list. I made my own function called contains-item. The code now reads: (contains-item? items-at-location item-symbol)"
17. "Is there a reason we're doing all the defines rather than use a let within the method?"
18. "Can you use square brackets for variable assignments in the let statements?"
19. "How would I use struct-copy in a let statement?"
20. "If I have an if statement and want the else to run two commands, how do I set that up?"
21. "Can you refactor this to use a let to define current-location?"
22. "Can you make both of those conditions without the else?"
23. "I have these two functions that are very similar. Can you refactor them into one function that relies on an inputted lambda for the behavior?"
24. "Could you give me more real-world explanations of milestones towards dehydration?"
25. "I would like 5 progressive, escalating steps along a path of dehydration towards death in my game."
