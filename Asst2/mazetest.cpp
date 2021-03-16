#include <stdlib.h>
#include <stdio.h>
#include "maze.h"

int numRows = 4, numCols = 4;    // maze size

Maze *theMaze;

void CreateMaze()
{
    theMaze = new Maze(numRows, numCols);
    theMaze->Create();
    
    // Dump the 2D view of the maze using ASCII text...
    int i, j;
    printf("2D overhead view of 3D maze:\n");
    for (i=numRows-1; i>=0; i--) {
        for (j=numCols-1; j>=0; j--) {    // top
            printf(" %c ", theMaze->GetCell(i, j).southWallPresent ? '-' : ' ');
        }
        printf("\n");
        for (j=numCols-1; j>=0; j--) {    // left/right
            printf("%c", theMaze->GetCell(i, j).eastWallPresent ? '|' : ' ');
            printf("%c", ((i+j) < 1) ? '*' : ' ');
            printf("%c", theMaze->GetCell(i, j).westWallPresent ? '|' : ' ');
        }
        printf("\n");
        for (j=numCols-1; j>=0; j--) {    // bottom
            printf(" %c ", theMaze->GetCell(i, j).northWallPresent ? '-' : ' ');
        }
        printf("\n");
    }
}


int main(int argc, char** argv)
{
    // Get program arguments
    if (argc > 1) {
        if (sscanf(argv[1], "%d", &numRows) != 1) {
            fprintf(stderr, "Did not understand number of rows specified <%s>\n", argv[1]);
            exit(1);
        }
        if (argc > 2) {
            if (sscanf(argv[2], "%d", &numCols) != 1) {
                fprintf(stderr, "Did not understand number of columns specified <%s>\n", argv[2]);
                exit(1);
            }
        }
        if (argc > 3) {
            fprintf(stderr, "Extra arguments specified - ignoring!\n");
        }
    }
    CreateMaze();
    return 0;
}
