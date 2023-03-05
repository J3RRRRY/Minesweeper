import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int numMines = 45;
public int totalRevealed = 0;
public boolean lose = false;
public boolean win = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    
    setMines();
}
public void setMines()
{
  while(mines.size() < numMines){
    int rows = (int)(Math.random()*NUM_ROWS);
    int cols = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[rows][cols])){
      mines.add(buttons[rows][cols]);
    }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        if(buttons[r][c].isRevealed() == true) {
          totalRevealed++;
          buttons[r][c].setRevealed(false);
        }
}
public boolean isWon()
{
  if(numMines + totalRevealed == NUM_ROWS*NUM_COLS && !lose)
    return true;
  return false;
  
}
public void displayLosingMessage()
{
  if(win == false) {
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i, j);
      }
    }
    buttons[0][0].setLabel("Y");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("U");
    buttons[0][3].setLabel("");
    buttons[0][4].setLabel("L");
    buttons[0][5].setLabel("O");
    buttons[0][6].setLabel("S");
    buttons[0][7].setLabel("T");
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(mines.contains(buttons[r][c])){
          buttons[r][c].setClicked(true);
        }
      }
    }
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(mines.contains(buttons[r][c])){
          buttons[r][c].draw();
        }
      }
    }
  }
}
public void displayWinningMessage()
{
    buttons[0][0].setLabel("Y");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("U");
    buttons[0][3].setLabel("");
    buttons[0][4].setLabel("W");
    buttons[0][5].setLabel("O");
    buttons[0][6].setLabel("N");
    buttons[0][7].setLabel("!");
    win = true;
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < 20 && c >= 0 && c < 20) return true;
    else
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
    private boolean revealed;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
        revealed = false;
    }

    // called by manager
    public void mousePressed () 
    {
      clicked = true;
      if(mouseButton == RIGHT) {
        if(flagged == true) {
          flagged = false;
          clicked = false;
         }else {
          flagged = true;
         }  
      }else if(mines.contains(this)) {
         displayLosingMessage();
         lose = true;
      }else if(countMines(myRow, myCol) > 0) {
        setLabel(countMines(myRow, myCol));
        revealed = true;
      }else {
        revealed = true;
        if(isValid(myRow - 1, myCol - 1) == true && !buttons[myRow - 1][myCol - 1].isClicked())
          buttons[myRow - 1][myCol - 1].mousePressed();
        if(isValid(myRow - 1, myCol) == true && !buttons[myRow - 1][myCol].isClicked())
          buttons[myRow - 1][myCol].mousePressed();
        if(isValid(myRow - 1, myCol + 1) == true && !buttons[myRow - 1][myCol + 1].isClicked())
          buttons[myRow - 1][myCol + 1].mousePressed();
        if(isValid(myRow + 1, myCol) == true && !buttons[myRow + 1][myCol].isClicked())
          buttons[myRow + 1][myCol].mousePressed();
        if(isValid(myRow + 1, myCol - 1) == true && !buttons[myRow + 1][myCol - 1].isClicked())
          buttons[myRow + 1][myCol - 1].mousePressed();
        if(isValid(myRow + 1, myCol + 1) == true && !buttons[myRow + 1][myCol + 1].isClicked())
          buttons[myRow + 1][myCol + 1].mousePressed();
        if(isValid(myRow, myCol + 1) == true && !buttons[myRow][myCol + 1].isClicked())
          buttons[myRow][myCol + 1].mousePressed();
        if(isValid(myRow, myCol - 1) == true && !buttons[myRow][myCol - 1].isClicked())
          buttons[myRow][myCol - 1].mousePressed();
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
        text(myLabel,x+width/2,y+height/2);
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
    public void setClicked(boolean click)
    {
      clicked = click;
    }
    public boolean isRevealed()
    {
      return revealed;
    }
    public void setRevealed(boolean reveal)
    {
      revealed = reveal;
