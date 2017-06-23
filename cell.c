#include <stdio.h>
extern int WorldLength;
extern char state[];
extern int WorldWidth;

char nextState( int location,int countNeighbors);
char Cell(int x ,int y){
	int location,offsetI,offsetJ , i, j;
	int countNeighbors=0;
	for( i=x-1;i<x+2;i++){
		for( j=y-1;j<y+2;j++){
			if(i!=x || j!=y){
			offsetI=i;
			offsetJ=j;
			//fix Offsets.
                        if(!(i!=WorldLength)){
				offsetI=0;
			}
			if(!(j!=WorldWidth)){
				offsetJ=0;
			}
			if(i<0){
				offsetI=WorldLength-1;
			}
			if(j<0){
				offsetJ=WorldWidth-1;
			}
			
			location= offsetI* WorldWidth +offsetJ;
                        
			if(state[location]>'0'){
				countNeighbors++;
			}
                    }
                }
	}

	location= x* WorldWidth +y;
        return (nextState(location,countNeighbors) );
}

char nextState( int location,int countNeighbors){
    int retVal= state[location];
    	if(retVal>'0'){ 
            //live cell;
		if(countNeighbors==3 ||countNeighbors==2){ 
                    
			if(retVal<'9'){
				retVal++; //increase lifeTime.	
			}
                        return retVal;
		}
		else{
			return '0';
		}
	}
	else{ 
		if(countNeighbors!=3){
			return '0';
		}
		else{
			return '1'; 
		}
	}
}
