import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 40;
public final static int NUM_COLS = 40;
public final static int NUM_MINES = 150;
public boolean lost = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();//ArrayList of just the minesweeper buttons that are mined


void setup () {
  size(800, 800);
  textAlign(CENTER,CENTER);
  // make the manager
  Interactive.make( this );
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_ROWS];
  for(int r = 0;  r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setMines(NUM_MINES);
}

public void setMines(int num) {
  for(int i = 0; i < num; i++) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if(!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    } else {
      i--;
    }
  }
}

public void draw () {
  background( 0 );
  if(isWon() == true) {
    displayWinningMessage();
  }
}

public boolean isWon() {
  int countFlagged = 0;
  int countClicked = 0;
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      if(buttons[r][c].isFlagged()) {
        countFlagged += 1;
      } else if(buttons[r][c].isClicked()) {
       countClicked += 1;
      }
    }
  }
  int countMines = 0;
  for(int i = 0; i < mines.size(); i++) {
    if((mines.get(i)).isFlagged()) {
      countMines += 1;
    }
  }
  if(countMines == NUM_MINES && countFlagged + countClicked == NUM_ROWS*NUM_COLS && countMines == countFlagged) {
    return true;
  }
  return false;
}

public void displayWinningMessage() {
  buttons[19][16].setLabel("Y");
  buttons[19][17].setLabel("O");
  buttons[19][18].setLabel("U");
  //buttons[19][19].setLabel(" ");
  buttons[19][20].setLabel("W");
  buttons[19][21].setLabel("I");
  buttons[19][22].setLabel("N");
}

public boolean isValid(int r, int c) {
  if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
  return false;
}

public int countMines(int row, int col)
{
  int numMines = 0;
  if(isValid(row - 1, col - 1) == true && mines.contains(buttons[row - 1][col - 1]) == true)
    numMines++;
  if(isValid(row - 1, col) == true && mines.contains(buttons[row - 1][col]) == true)
    numMines++;
  if(isValid(row - 1, col + 1) == true && mines.contains(buttons[row - 1][col + 1]) == true)
    numMines++;
  if(isValid(row + 1, col) == true && mines.contains(buttons[row + 1][col]) == true)
    numMines++;
  if(isValid(row + 1, col - 1) == true && mines.contains(buttons[row + 1][col - 1]) == true)
    numMines++;
  if(isValid(row + 1, col + 1) == true && mines.contains(buttons[row + 1][col + 1]) == true)
    numMines++;
  if(isValid(row, col + 1) == true && mines.contains(buttons[row][col + 1]) == true)
    numMines++;
  if(isValid(row, col - 1) == true && mines.contains(buttons[row][col - 1]) == true)
    numMines++;
  return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }  
    // called by manager
    public void mousePressed () 
    {
      if(lost == false) {
        if(mouseButton==LEFT && !buttons[myRow][myCol].isFlagged()) {
        clicked = true;
        }
        if(mouseButton==RIGHT && !buttons[myRow][myCol].isClicked()) {
          flagged = !flagged;
        } else if(mines.contains(buttons[myRow][myCol])) {
          lost = true;
        } else if(countMines(myRow, myCol) != 0) {
          setLabel(countMines(myRow, myCol));
        } else {
          if(isValid(myRow, myCol-1) == true && !buttons[myRow][myCol-1].isClicked()) {
          buttons[myRow][myCol-1].mousePressed();  
          }
          if(isValid(myRow-1, myCol) == true && !buttons[myRow-1][myCol].isClicked()) {
          buttons[myRow-1][myCol].mousePressed(); 
          }
          if(isValid(myRow, myCol+1) == true && !buttons[myRow][myCol+1].isClicked()) {
          buttons[myRow][myCol+1].mousePressed(); 
          }
          if(isValid(myRow+1, myCol) == true && !buttons[myRow+1][myCol].isClicked()) {
          buttons[myRow+1][myCol].mousePressed(); 
          }
        }
      }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(10);
        text(myLabel,x+width/2,y+height/2);
        if(lost == true) {
        buttons[19][16].setLabel("Y");
        buttons[19][17].setLabel("O");
        buttons[19][18].setLabel("U");
        //buttons[19][19].setLabel(" ");
        buttons[19][20].setLabel("L");
        buttons[19][21].setLabel("O");
        buttons[19][22].setLabel("S");
        buttons[19][23].setLabel("E");
        for(int r = 0; r < NUM_ROWS; r++) {
          for(int c = 0; c < NUM_COLS; c++) {
            if(mines.contains(buttons[r][c]) && clicked == false)
            {
              lost = false;  
              buttons[r][c].mousePressed();
            }
            lost = true;
          }
        }
      }
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
        return clicked;
    }
}
