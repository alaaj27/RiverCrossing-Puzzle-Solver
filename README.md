<!-- Coursera-Machine-Learning-Stanford is being sponsored by the following tool; please help to support us by taking a look and signing up to a free trial
<a href="https://tracking.gitads.io/?repo=Coursera-Machine-Learning-Stanford"><img src="https://images.gitads.io/Coursera-Machine-Learning-Stanford" alt="GitAds"/></a> -->

# Game Theory and Graph Search Methods:
Solving the well known game vampires and Werewolves (river-crossing) puzzle using general search algorithms such as Breadth-First Search (BFS), Depth-First Search DFS , and Best First Search (Heuristic search).

# River Crossing Puzzle:
Three vampires and three werewolves are on the east side of a river, along with a boat that can hold one or two creatures. We need to safely move all creatures to the west side under certain conditions that need to be met. First, number of werewolves must be less than or equal the number of the vampires in both sides at each state.  Second, the boat can hold up to two creatures at a time. Finally the boat cannot cross the river empty.


<img width="422" alt="Screen Shot 2022-01-10 at 7 16 13 PM" src="https://user-images.githubusercontent.com/37596986/148869621-42ebfab5-a511-4ad4-a45d-b899a3ad1c86.png">




### Run the Vampire and Werewolves (4x4 Puzzle) problem:
* install [swipl](https://www.swi-prolog.org/download/stable) in your machine.
* To run a sliding tile program interactively for BFS, DFS, or HFS, respectively, use: <br/>
swipl  ./bfs.pl ./vamp-wolf.pl <br/>
swipl  ./dfs.pl ./vamp-wolf.pl <br/>
swipl  ./hfs.pl ./vamp-wolf.pl <br/>

* Run the "go" command: <br/>
go(StartState, GoalState). -example:  go([3,3,0,0,east] , [0,0,3,3,west]).

## References
[[1] Luger's code](https://www.cs.unm.edu/~luger/)
