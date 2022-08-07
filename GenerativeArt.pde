//IMPORTS
import peasy.*;
PeasyCam cam;


//VARIABLES
int num = 0;
float r, g, b;
boolean run;
boolean capture;
int range;
float canvasDepth;
ArrayList<ArrayList<Line>> lines;
ArrayList<ArrayList<Paint>> paints;
int lineCount = 1;
boolean menu;

void setup()
{
  //SETTINGS
  fullScreen(P3D);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  shapeMode(CENTER);
  frameRate(144);
  strokeJoin(ROUND);

  //VARIABLE DECLARATION
  lines = new ArrayList<ArrayList<Line>>();
  paints = new ArrayList<ArrayList<Paint>>();
  cam = new PeasyCam(this, 3000);
  cam.setActive(true);
  cam.setYawRotationMode();
  cam.setCenterDragHandler(null);
  cam.setRightDragHandler(null);
  run = true;
  capture = false;
  range = 50;
  canvasDepth = -width * 2;
  menu = false;
  makeLines();
}

void draw()
{
  background(0);

  //ADDS NEW LINES FOR EACH STRAND
  if (run && !capture)
  {
    for (int i = 0; i < lines.size(); i++)
    {
      lines.get(i).add(new Line(lines.get(i).get(lines.get(i).size()-1).x + random(-range, range), lines.get(i).get(lines.get(i).size()-1).y + random(-range, range), lines.get(i).get(lines.get(i).size()-1).z + random(-range, range), lines.get(i).get(lines.get(i).size()-1), r, g, b));
    }
  }

  //RENDERS ALL LINES IN EVERY STRAND
  for (int i = 0; i < lines.size(); i++)
  {
    for (int j = 0; j < lines.get(i).size(); j++)
    {
      lines.get(i).get(j).render();

      //MOVES STRANDS TOWARDS CANVAS THEN MAPS POSITOINS INTO PAINT
      if (capture)
      {
        if (lines.get(i).get(j).z > -width * 2)
        {
          lines.get(i).get(j).drop();
        } else if (inBounds(lines.get(i).get(j).x, lines.get(i).get(j).y))
        {
          Line temp = lines.get(i).get(j);
          if (j != 0 && paints.get(i).size() > 0)
          {
            paints.get(i).add(new Paint(temp.x, temp.y, temp.r, temp.g, temp.b, paints.get(i).get(paints.get(i).size()-1)));
          } else
          {
            paints.get(i).add(new Paint(temp.x, temp.y, temp.r, temp.g, temp.b, null));
          }
          lines.get(i).remove(temp);
        } else if (!inBounds(lines.get(i).get(j).x, lines.get(i).get(j).y))
        {
          lines.get(i).remove(j);
        } else
        {
          lines.get(i).remove(j);
        }
      }
    }
  }

  //RENDERS ALL PAINT
  for (int i = 0; i < paints.size(); i++)
  {
    pushMatrix();
    beginShape();
    strokeJoin(ROUND);
    noFill();
    translate(0, 0, canvasDepth);
    for (int j = 0; j < paints.get(i).size(); j++)
    {
      Paint temp = paints.get(i).get(j);
      stroke(temp.r, temp.g, temp.b, temp.o);
      strokeWeight(temp.w);
      curveVertex(temp.x, temp.y);
    }
    endShape();
    popMatrix();
  }
  
  //MOVES CANVAS TO SCREEN THEN ALLOWS FOR SCREENSHOT
  if (capture)
  {
    pushMatrix();
    translate(0, 0, canvasDepth);
    fill(255);
    stroke(255, 0, 0);
    strokeWeight(10);
    rect(0, 0, width * 2, height * 2);
    popMatrix();

    int tempSize = 0;
    for (int i = 0; i < lines.size(); i++)
    {
      tempSize += lines.get(i).size();
    }
    if (tempSize == 0)
    {
      canvasDepth = width * .75;
      cam.reset(0);
      cam.setActive(false);
    }
  }

  //CHANGES COLORS
  r += random(0, 5);
  g += random(0, 5);
  b += random(0, 5);
  r %= 255;
  g %= 255;
  b %= 255;

  //TEXT
  textSize(200);
  fill(r, g, b);
  pushMatrix();
  translate(0, height, 0);
  rotateX(frameCount * .01);
  text("Danielian Softworks®\nPush 'P' for options", 0, 0);
  popMatrix();
  
  //RENDERS OPTION MENU
  if (menu)
  {
    pushMatrix();
    hint(DISABLE_DEPTH_TEST);
    translate(0, 0, width/2);
    rotateX(PI/6);
    fill(255);
    noStroke();
    rect(0, -height/2, width, height * 1.75, 50);
    fill(0);
    text("Press Keys:\nC: Cast to Canvas\nS: Save Screenshot\nSpace Bar: Pause/Play\nA: Add New Strand\nR: Restart", 0, -height/2);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
}

//CHECKS IF PAINT IS IN BOUNDS
boolean inBounds(float x, float y)
{
  if (x >= -width && x <= width && y < height && y > -height)
  {
    return true;
  }
  return false;
}

//KEY INPUTS
void keyPressed()
{
  if (key == 'a' && !capture)
  {
    makeLines();
    lineCount++;
  } else if (key == ' ' && !capture)
  {
    run = !run;
  } else if (key == 'r')
  {
    setup();
  } else if (key == 'c' && !capture)
  {
    capture = true;
    run = false;
    for (int i = 0; i < lines.size(); i++)
    {
      paints.add(new ArrayList<Paint>());
    }
  } else if (key == 's')
  {
    saveFrame("art-######.png");
    setup();
  } else if (key == 'p')
  {
    menu = !menu;

    if (menu)
    {
      run = false;
    } else if (!menu)
    {
      run = true;
    }
  }
}
