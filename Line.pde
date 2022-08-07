//REPRESENDS A POINT IN 3D SPACE AND HAS REFRERENCE TO THE LAST POINT
class Line
{
  float x, y, z;
  float r, g, b;
  Line lastLine;
  float zMover;
  public Line(float x, float y, float z, Line lastLine, float r, float g, float b)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.r = r;
    this.g = g;
    this.b = b;
    this.lastLine = lastLine;
    zMover = 0;
  }

  //RENDERS A LINE TO FROM NEW POINT TO LAST POINT
  void render()
  {
    pushMatrix();
    translate(x, y, z);
    fill(r, g, b);
    noStroke();
    popMatrix();
    if (lastLine != null)
    {
      strokeWeight(5);
      stroke(r, g, b);
      line(x, y, z, lastLine.x, lastLine.y, lastLine.z);
    }
    
    z += zMover;
  }
  
  //CHANGES ZMOVER TO CAST TO CANVAS
  void drop()
  {
    if(zMover == 0)
    {
      zMover = -.1;
    }
    else
    {
      zMover *= 1.02;
    }
  }
}

//MAKES NEW LINES
void makeLines()
{
  ArrayList<Line> temp = new ArrayList<Line>();
  lines.add(temp);
  lines.get(lines.size()-1).add(new Line(0, 0, 0, null, r, g, b));
}
