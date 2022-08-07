//REPRESENTS A SERIES OF POINTS TO ADD INTO CURVED LINE
class Paint
{
  float x, y, z;
  float r, g, b;
  float w, o;
  Paint last;

  public Paint(float x, float y, float r, float g, float b, Paint last)
  {
    this.x = x;
    this.y = y;
    z = canvasDepth + 10;
    this.r = r;
    this.g = g;
    this.b = b;
    this.last = last;
    if (last != null)
    {
      w = last.w + random(-.1, .1);
    } else
    {
      w = random(5, 20);
    }
    o = random(200, 255);
  }
}
