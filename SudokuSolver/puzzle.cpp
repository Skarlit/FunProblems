//Author: Ran Xie

#include "puzzle.h"

Puzzle::Puzzle(const char grid[][9]){   
  flag=false;      //flag for successful move 
  for(int i=0;i<9;i++)
  {
    for(int j=0;j<9;j++)
    {
      if(grid[i][j]=='*')   // we push the grids with '*' on the stack
      {                     // as coord, (i,j,'0')
          coord spot;
          spot.i=i;
          spot.j=j;
          spot.k='0';
          LoadedSpots.push(spot);
      }
    }
  }
}

//*****************************************************************************************************************************
//Returns false if there is conflict
//Returns true if the value can be placed
//*****************************************************************************************************************************
bool Puzzle::LinearScanner(const char grid[][9],coord spot){

  for(int count=0;count<9;count++)   
  {
    if(spot.j!=count && grid[spot.i][count]==spot.k) //This checks for conflicts on row spot.i
    { return false;}
    if(spot.i!=count && grid[count][spot.j]==spot.k) //This checks for conflicts on col spot.j
    { return false;}
  }
  return true;
}

//This use the coord struct to store quotient and remainder when divided by 3 as i and j
coord Puzzle::QuoRem(int num){
  coord QR={0,0,'0'};
    
  while(num>=3){
      num=num-3;  
      QR.i++;   
  }
  QR.j=num;
  return QR;
}

//*****************************************************************************************************************************
//Returns false if there is conflict
//Returns true if the value can be placed
//*****************************************************************************************************************************
bool Puzzle::BlockScanner(const char grid[][9],coord spot){
  //Locate the block (x,y) for (i,j)
  (spot.i)++;
  (spot.j)++;
  coord Block_i=QuoRem(spot.i);
  coord Block_j=QuoRem(spot.j);
  int Block_x,Block_y;   //Use this to hold the block (x,y) where (i,j) is
  if(Block_i.j==0)   //If remainder is 0,then the block_x is the quotient, else increment by 1
     Block_x=Block_i.i;
  else Block_x=Block_i.i+1;
  if(Block_j.j==0) //If remainder is 0,then the block_y is the quotient, else increment by 1
     Block_y=Block_j.i;
  else Block_y=Block_j.i+1;

  //Once we have located the block, we scan the block by traversing
  int start_x=3*Block_x-3;  //The starting grid for the block we located above
  int start_y=3*Block_y-3;
   (spot.i)--;   //After locating the blocks, we need to decrement them again -.-
   (spot.j)--;
   //cout<<"("<<start_x<<","<<start_y<<")"<<endl;  //DEBUGGING LINE
  for(int m=0;m<3;m++){    //Scan the whole 3x3 block skipping (i,j)
      for (int n=0;n<3;n++){
	//cout<<"("<<start_x+m<<","<<start_y+n<<")"<<endl;  //DEBUGGING LINE
          if(start_x+m==spot.i && start_y+n==spot.j){;}        
          else
              {
	 // cout<<grid[start_x+m][start_y+n]<<endl; //DEBUGGING LINE
               if(grid[start_x+m][start_y+n]==spot.k)
               {return false;}
              }
      }
  }
  return true;
}

//*****************************************************************************************************************************
//This solves the input sudoku then fill in the answer
//METHOD: I utilize two stacks SavedMoves and LoadedSpots. LoadedSpots loads all the * spots.
//While SavedMoves saves the move that is valid, and when a move is valid, LoadedSpots is popped
//While there is not valid move available, backtracking is needed. When a backtrack move works,
//I also have to reset the move right underneath the valid move on LoadedSpot to '0'
//This turns out of be extremely important since if (6,7,4) is on top of (6,6,3), if (6,7,5) works,
//(6,6,4) will be tried next, by doing this, (6,6,1),(6,6,2) which are possible move are ignored which will lead to no solution
//***************************************************************************************************************************** 
void Puzzle::solve(char grid[][9]){
  while(!LoadedSpots.isEmpty()){
	  flag=false;
    coord testspot=LoadedSpots.top();
    while(testspot.k<'9' && flag==false){ //try it up to 9. Escape after a successful move or it reaches 9  
      (testspot.k)++; //Increment k, if k=0, we start from 1. If k=8, we can always check 9 and escape the while loop.

      if(LinearScanner(grid,testspot) && BlockScanner(grid,testspot)){
                         
        SavedMoves.push(testspot);  //Save this move
        LoadedSpots.pop();         //Pop it from the loaded stack
        if(LoadedSpots.top().k!='0'){ //Since this move works if the previous k is not 0, we need to set it back to 0
          coord temp=LoadedSpots.topAndPop();
          temp.k='0';
          LoadedSpots.push(temp);
        }
        grid[testspot.i][testspot.j]=testspot.k; //Write it on the grid                                   
        flag=true; //Set flag =1 for successful move.
   
      }
      else {flag=false;} //If it doesn't work
    }

    if(flag==false){  //we backtrack when no successful move and when pos>1 
      coord temp=SavedMoves.topAndPop(); //Get the saved move from the Saved Stack and pop it
      grid[temp.i][temp.j]='0';
      LoadedSpots.push(temp);    //push it back in the Loaded stack and loop         
    }        
  }
}


//******************************************************************
//******************************************************************
//*********************coordStack Class DEFINTION*******************
//******************************************************************
//******************************************************************
coordStack::coordStack(){
  pos=0;
}

void coordStack::push(coord x){
  pos++;
  Array[pos]=x;	 
}

void coordStack::pop(){
  if(!isEmpty())  
	pos--;
}

coord coordStack::top(){
	if(!isEmpty()) 
	return Array[pos];
}

bool coordStack::isEmpty(){ 
  if(pos==0)
	return true;
  else return false;
}

coord coordStack::topAndPop(){
	coord temp=this->top();
	pos--;
	return temp;
}

void coordStack::reset(){pos=0;}

void coordStack::printTop(){ cout<<"("<<Array[pos].i<<","<<Array[pos].j<<","<<Array[pos].k<<","<<pos<<")"<<endl; }

