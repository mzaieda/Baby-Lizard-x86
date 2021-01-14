#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <queue>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

class BabyLizardGrid
{
public:
int gridSize = 0;
int noOfLizardsPlaced = 0;
int currentRow = 0;
vector<vector<int> > babyLizardVector;

public:
BabyLizardGrid(int setGridSize, int setNoOfLizardsPlaced, int setCurrentRow)
{
gridSize = setGridSize;
noOfLizardsPlaced = setNoOfLizardsPlaced;
currentRow = setCurrentRow;
babyLizardVector.resize(gridSize, vector<int>(gridSize));
}
};


bool CheckSafePosition(vector<vector<int> > babyLizardVector, int row, int column, int gridSize)
{
if (babyLizardVector[row][column] == 2)
return false;

int i, j;
//Check for current column upward
for (i = row; i >= 0; i--)
{
if (babyLizardVector[i][column] == 1)
{
return false;
}
else if (babyLizardVector[i][column] == 2)
{
break;
}
}

//Check for current column downward
for (i = row; i < gridSize; i++)
{
if (babyLizardVector[i][column] == 1)
{
return false;
}
else if (babyLizardVector[i][column] == 2)
{
break;
}
}

//Check for horizontal row to the left
for (i = column; i >= 0; i--)
{
if (babyLizardVector[row][i] == 1)
{
return false;
}
else if (babyLizardVector[row][i] == 2)
{
break;
}
}

//Check for horizontal row to the right
for (i = column; i < gridSize; i++)
{
if (babyLizardVector[row][i] == 1)
{
return false;
}
else if (babyLizardVector[row][i] == 2)
{
break;
}
}

//Check Upper Diagonal Upside
for (i = row, j = column; i >= 0 && j >= 0; i--, j--)
{
if (babyLizardVector[i][j] == 1)
{
return false;
}
else if (babyLizardVector[i][j] == 2)
{
break;
}
}

//Check Upper Diagonal Downside
for (i = row, j = column; i < gridSize && j < gridSize; i++, j++)
{
if (babyLizardVector[i][j] == 1)
{
return false;
}
else if (babyLizardVector[i][j] == 2)
{
break;
}
}

//Check down side diagonal Upside
for (i = row, j = column; j < gridSize && i >= 0; i--, j++)
{
if (babyLizardVector[i][j] == 1)
{
return false;
}
else if (babyLizardVector[i][j] == 2)
{
break;
}
}

//Check down side diagonal downside
for (i = row, j = column; i < gridSize && j >= 0; i++, j--)
{
if (babyLizardVector[i][j] == 1)
{
return false;
}
else if (babyLizardVector[i][j] == 2)
{
break;
}
}
return true;
}



//Check if goal is found
bool ChecGoalState(BabyLizardGrid grid, int noOfLizards)
{
if (grid.noOfLizardsPlaced == noOfLizards)
return true;
else
return false;
}


BabyLizardGrid FindDFSSolution(BabyLizardGrid babyLizardGrid, int gridSize, int noOfLizards, bool rootNode)
{
if (ChecGoalState(babyLizardGrid, noOfLizards))
{
return babyLizardGrid;
}
else
{
for (int row = 0; row < gridSize; row++)
{
for (int column = 0; column < gridSize; column++)
{
if (CheckSafePosition(babyLizardGrid.babyLizardVector, row, column, gridSize))
{
babyLizardGrid.babyLizardVector[row][column] = 1;
babyLizardGrid.noOfLizardsPlaced += 1;
babyLizardGrid.currentRow = row;

BabyLizardGrid finalBabyLizardGrid = FindDFSSolution(babyLizardGrid, gridSize, noOfLizards, rootNode);

if (finalBabyLizardGrid.noOfLizardsPlaced != 0)
{
return finalBabyLizardGrid;
}

if (babyLizardGrid.noOfLizardsPlaced > 0)
{
babyLizardGrid.noOfLizardsPlaced--;
if (babyLizardGrid.currentRow != 0)
babyLizardGrid.currentRow--;
babyLizardGrid.babyLizardVector[row][column] = 0;
}
}
}
}
}
return BabyLizardGrid(0, 0, 0);
}


int main(int argc, const char * argv[]) {
queue<BabyLizardGrid> babyLizardQueue;
vector<vector<int> > inputGrid;

int gridSize = 0;
int noOfLizards = 0;
bool ifSolutionFound = false;

string argumnets;

int lineIndex = 0;

lineIndex += 1;

cin>>   gridSize;   lineIndex += 1;
inputGrid.resize(gridSize, vector<int>(gridSize));

cin>>noOfLizards; lineIndex += 1;

for (int j = 0; j < gridSize; j++)
{  
   cin>>argumnets;
if (lineIndex - 3 < gridSize)
{
inputGrid[lineIndex - 3][j] = argumnets[j] - 48;
}

lineIndex += 1;
}
   
//Initialize Lizard Grid for DFS Search
BabyLizardGrid dfsBabyLizardGrid = BabyLizardGrid(gridSize, noOfLizards, 0);


//Initialize root Baby Lizard Grid
BabyLizardGrid rootBabyLizardGrid = BabyLizardGrid(gridSize, 0, 0);
rootBabyLizardGrid.noOfLizardsPlaced = 0;
rootBabyLizardGrid.babyLizardVector = inputGrid;



{
dfsBabyLizardGrid = FindDFSSolution(rootBabyLizardGrid, gridSize, noOfLizards, true);
if (dfsBabyLizardGrid.noOfLizardsPlaced == noOfLizards)
{
ifSolutionFound = true;
}
}

//Print the solution

if (ifSolutionFound)
{

for (int i = 0; i < gridSize; i++)
{
for (int j = 0; j < gridSize; j++)
{
cout << dfsBabyLizardGrid.babyLizardVector[i][j];
}

cout << endl;
}
}
else
{
cout << "FAIL" << endl;
}
}