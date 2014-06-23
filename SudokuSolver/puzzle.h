#ifndef PUZZLE_H
#define PUZZLE_H
#include <iostream>
using namespace std;

struct coord{
    int i,j;  //(i,j) grid
    char k;  //value held in (i,j) grid 
};

class coordStack{
	public:
	coordStack();
	void push(coord);
	void pop();
	coord top();
	coord topAndPop();
	bool isEmpty();
	void reset();
	void printTop();
	private:
	coord Array[100];
	int pos;
	friend class Puzzle;
};


class Puzzle
{
 public:
  Puzzle(const char grid[][9]);
  void solve(char grid[][9]);
 //private:
    bool LinearScanner(const char grid[][9],coord spot); //scan vertically and horizontally
    coord QuoRem(int num);   //This computes the quotient and remainder of num
    bool BlockScanner(const char grid[][9],coord spot); //scan the 3x3 blocks
    coordStack SavedMoves;
    coordStack LoadedSpots;
    bool flag;   //flag for sucessful move or not
    
}; // Puzzle class

#endif

