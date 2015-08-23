/* 
  @pjs font='font/Snake.ttf'; 
  preload='sprite/Base.png,sprite/Outline.png,sprite/Leather.png,sprite/Cloth.png,sprite/Neutral.png,sprite/Battle.png,sprite/Helmet.png,sprite/lostLeather.png,sprite/lostCloth.png,sprite/lostKnight.png,sprite/lostHelmet.png,sprite/Swordfight.png'; 
*/ 

var myfont = loadFont("font/Snake.ttf"); 

boolean isChallenging = false;

boolean hasChallenger = false;

boolean killornot = false;

int State = 0;

ArrayList contacts;

ArrayList textlines;

ArrayList tools;

float cskill = 1;

float pskill = 15;

float fdist = 0;

float mph = 20;
float ph = 20;
float money = 0;

float restime = 0;

float width;
float height;
float theight;
float cheight;
boolean viewStats = false;
float statv = 0;
float evil = 1000/2;
float evilm = 0;
float demonskill = 0;
float rskill = 1;

PImage[] knight = new PImage[7];
PImage[] lknight = new PImage[4];
PImage sf; 
PImage hb; 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
}; 
 
void setup() { 
  //noCursor();
  width = window.innerWidth - 20; 
  height = window.innerHeight - 20; 
  theight = height*9/10;
  cheight = height/10;
  size(width,height); 
    
  knight[0] = loadImage('sprite/Base.png');
  knight[1] = loadImage('sprite/Outline.png');
  knight[2] = loadImage('sprite/Cloth.png');
  knight[3] = loadImage('sprite/Leather.png');
  knight[4] = loadImage('sprite/Neutral.png');
  knight[5] = loadImage('sprite/Battle.png');
  knight[6] = loadImage('sprite/Helmet.png');
  
  lknight[0] = loadImage('sprite/lostCloth.png');
  lknight[1] = loadImage('sprite/lostLeather.png');
  lknight[2] = loadImage('sprite/lostKnight.png');
  lknight[3] = loadImage('sprite/lostHelmet.png');

  sf = loadImage('sprite/Swordfight.png');
  hb = loadImage('sprite/Healthbar.png');    
    
  contacts = new ArrayList();
  tools = new ArrayList();
  textlines = new ArrayList();
  textFont(myfont,45);  
  textlines.add(new Textline("Thou overheard the Duke of Agraolind's plans to overthrow the king.",color(255,255,255)));
  textlines.add(new Textline("Rival knights ambush'd and slash'd thy face at the Duke's hest.",color(255,255,255)));
  textlines.add(new Textline("Thou escap'd and vow'd f'r revenge. The time hath come!",color(255,255,255)));
}
 
void draw() {
  if (restime > 0) {restime -= 1;}
  width = window.innerWidth - 20; 
  height = window.innerHeight - 20; 
  theight = height*9/10;
  cheight = height/10;
  size(width,height); 
  background(0);
  for (int i=contacts.size()-1; i>=0; i--) {
    Particle c = (Contact) contacts.get(i);
    c.update();
    if (c.hp == -13458) {contacts.remove(i);}
  }
  for (int i=tools.size()-1; i>=0; i--) {
    Particle t = (Tool) tools.get(i);
    t.update();
    if (t.h <= 0) {tools.remove(i);}
  }

  for (int i=textlines.size()-1; i>=0; i--) {
    Particle l = (Textline) textlines.get(i);
    l.update();
    if (l.y <= -40) {textlines.remove(i);}
  }
  
  if (!isChallenging || killornot) {
    if (!killornot) {if (fdist > 0) {fdist -= dist(0,0,fdist,0)/4;}}
    textAlign(LEFT,TOP);
    if (mouseX.between(0,width/2) && mouseY.between(theight,height)) {
      fill(255,200,150);
      stroke(255,200,150);
    } else {
      fill(255);
      stroke(255);
    }
    if (killornot) {text("To kill...",width/6,theight);} else {text("Challenge the Duke",width/6,theight);}
    fill(0,0);
    rect(0,theight,width/2,cheight-2);
        
    textAlign(RIGHT,TOP);
    if (mouseX.between(width/2,width) && mouseY.between(theight,height)) {
      fill(255,200,150);
      stroke(255,200,150);
    } else {
      fill(255);
      stroke(255);
    }
    if (killornot) {text("'r not to kill?",width - width/6,theight);} else {
      if (restime <= 0) {text("Rob the Duke",width - width/6,theight);} else {
        fill(150);
        stroke(150);
        text("Thou need to rest!",width - width/6,theight);
      }
    }
    fill(0,0);
    rect(width/2,theight,width/2 - 1,cheight-2);
  }
  if (random(1) > 0.99 && isChallenging && !hasChallenger) {
      if (contacts.size() >= 1 && random(1) > 0.9) {
        hasChallenger = true;
        Particle c = (Contact) contacts.get(round(random(contacts.size()-1)));
        c.action = 5;
        c.speak = 0;
      } else {
        contacts.add(new Contact());
      }
  }
  drawKnight(width/6 + fdist,theight-knight[0].width,color(255,0,0),color(255,0),color(255,0),false,true,true);
  if (viewStats) {
    if (statv < width/2) {statv += dist(statv,0,width/2,0)/4;}
  } else {
    if (statv > 0) {statv -= dist(statv,0,0,0)/4;}
    stroke(255);
    fill(0);
    rect(width - 50 - statv,height/2 - 50,50,100);
    textAlign(RIGHT,CENTER);
    fill(255);
    text("<<",width - statv,height/2);
  }
  if (statv > 1) {
    stroke(255);
    fill(0);
    rect(width - statv,height/4,statv,height/2);
    drawKnight(width - statv,height/4,color(255,0,0),color(255,0),color(255,0),false,true,false);
    textAlign(LEFT,TOP);
    fill(255);
    if (evil < 100) {
      text("The Forgiv'r of Agraolind",width - statv + knight[0].width, height/4);
    } else if (evil < 150) {
      text("The Vigilante of Agraolind",width - statv + knight[0].width, height/4);
    } else if (evil < 200) {
      text("The Mask'd Knight",width - statv + knight[0].width, height/4);
    } else if (evil < 300) {
      text("The Discard'd Knight",width - statv + knight[0].width, height/4);
    } else if (evil < 400) {
      text("The Scarred Knight",width - statv + knight[0].width, height/4);
    } else if (evil <= 500) {
      text("The Defaced Knight",width - statv + knight[0].width, height/4);
    } else if (evil < 600) {
      text("The Undead Knight",width - statv + knight[0].width, height/4);
    } else if (evil < 700) {
      text("The Betrayer",width - statv + knight[0].width, height/4);
    } else if (evil < 800) {
      text("The Duke's Nightmare",width - statv + knight[0].width, height/4);
    } else if (evil < 900) {
      text("The Killer of Agraolind",width - statv + knight[0].width, height/4);
    } else {
      text("Bringer of Death",width - statv + knight[0].width, height/4);
  }
  stroke(150,150,255);
  fill(150,150,255);
  rect(width - statv + knight[0].width, height/4 + 50,(width/2 - knight[0].width)*((1000 - evil)/1000),10);
  stroke(255,100,100);
  fill(255,100,100);
  rect(width - statv + knight[0].width + (width/2 - knight[0].width)*((1000 - evil)/1000), height/4 + 50,width/2,10);
  fill(255,255,150);
  textAlign(LEFT,TOP);
  text(money + " Chinks",width - statv + knight[0].width, height/4 + 80);
  fill(255);
  text("Skill level: " + pskill,width - statv + knight[0].width, height/4 + 50);
  text(ph + "/" + mph + " HP",width - statv + knight[0].width, height/4 + 110);
  stroke(255);
  fill(0);
  rect(width - statv + 10,height/2,(width-100)/10,height/4.2);
  rect(width - statv + 15 + (width-100)/10,height/2,(width-100)/10,height/4.2);
  rect(width - statv + 20 + (width-100)*2/10,height/2,(width-100)/10,height/4.2);
  rect(width - statv + 25 + (width-100)*3/10,height/2,(width-100)/10,height/4.2);
  rect(width - statv + 30 + (width-100)*4/10,height/2,(width-100)/10,height/4.2);
  textAlign(CENTER,TOP);
  fill(150,255,150);
  text("Herbs",width - statv + 10 + (width-100)/20,height/2);
  fill(255,200,150);
  text("Ritual",width - statv + 15 + (width-100)/10 + (width-100)/20,height/2);
  fill(255,255,150);
  text("Key",width - statv + 20 + (width-100)*2/10 + (width-100)/20,height/2);
  fill(150,150,255);
  text("Rebirth",width - statv + 25 + (width-100)*3/10 + (width-100)/20,height/2);
  fill(255,150,150);
  text("Soulcatch",width - statv + 30 + (width-100)*4/10 + (width-100)/20,height/2);
  textFont(myfont,30); 
  fill(255);
  text("Heal " + round(10-demonskill/10) + " HP",width - statv + 10 + (width-100)/20,height/2 + 45);
  text("Contract T" + (demonskill + 1),width - statv + 15 + (width-100)/10 + (width-100)/20,height/2 + 45);
  text("Fake Key T" + (rskill + 1),width - statv + 20 + (width-100)*2/10 + (width-100)/20,height/2 + 45);
  text("Go to heaven.",width - statv + 25 + (width-100)*3/10 + (width-100)/20,height/2 + 45);
  text("Kill the Duke.",width - statv + 30 + (width-100)*4/10 + (width-100)/20,height/2 + 45);
  fill(255,255,150);
  textAlign(CENTER,BOTTOM);
  text("8 Chinks",width - statv + 10 + (width-100)/20,height/2 + height/4.2);
  text((demonskill+1)*5 + " Chinks",width - statv + 15 + (width-100)/10 + (width-100)/20,height/2 + height/4.2);
  text((rskill)*6 + " Chinks",width - statv + 20 + (width-100)*2/10 + (width-100)/20,height/2 + height/4.2);
  text("Be good.",width - statv + 25 + (width-100)*3/10 + (width-100)/20,height/2 + height/4.2);
  text("Be evil.",width - statv + 30 + (width-100)*4/10 + (width-100)/20,height/2 + height/4.2);
  textFont(myfont,45); 
  }
}

void mousePressed() {
  if (mouseX.between(0,width/2) && mouseY.between(theight,height)) {
    if (killornot) {
      for (int i=contacts.size()-1; i>=0; i--) {
        Particle c = (Contact) contacts.get(i);
        if (c.action == 2) {
            c.hp = -13458;
            if (c.trust < 80) {
              evil += 15 + evilm;
              evilm += 0.15;
              textlines.add(new Textline("With a quick paunch thou end " + c.order + " " + c.name + "'s life.",color(255,255,150)));
              pskill += round(random(2));
              money += round(random(c.skill*2));
            } else {
              evil += 25 + evilm;
              evilm += 5;
              pskill += round(random(2));
              textlines.add(new Textline("Thou betray'd " + c.name + ". A caterwauling of agony erupts in thy lair.",color(255,150,150)));
            }
        }
      }
      killornot = false;
      isChallenging = false;
      hasChallenger = false;
      tools.add(new Tool(width - width/6 - fdist + knight[0].width/2));
    } else  if (!isChallenging) {
      textlines.add(new Textline("Thou wrote to the Duke: Come face me, foul beast!",color(255,255,150)));
      isChallenging = true;
    }
  }
  if (mouseX.between(width/2,width) && mouseY.between(theight,height)) {
    if (killornot) {
      for (int i=contacts.size()-1; i>=0; i--) {
        Particle c = (Contact) contacts.get(i);
        if (c.action == 2) {
            c.action = 4;
            if (c.trust < 80) {
              evil -= 10;
              evilm -= 0.3;
              textlines.add(new Textline("Thou spared " + c.order + " " + c.name + " and he escap'd.",color(255,255,150)));
              pskill += round(random(1));
              c.trust += random(-10,10);
            } else {
              evil -= 2;
              evilm -= 0.15;
              textlines.add(new Textline(c.name + " bids farewell and leaves.",color(255,255,255)));
            }
        }
      }
      killornot = false;
      isChallenging = false;
      hasChallenger = false;
    } else if (!isChallenging && restime <= 0) {
      if (random(10) < rskill) {
        money += round(random(cskill*3));
        textlines.add(new Textline("With thy key, thou sneak into the duke's mansion and stole some chinks.",color(255,255,150)));
      } else {
        money += round(random(cskill*1.5));
        textlines.add(new Textline("Thou got attack'd while lurking in the duke's mansion but thou escap'd.",color(255,150,150)));
        ph -= ceil(random(cskill/2));
        restime = 500;
      }
    }
  }
  if (!viewStats && mouseX.between(width-50,width) && mouseY.between(height/2-50,height/2+50)) {
    viewStats = true;
  }
  if (viewStats && !(mouseX.between(width/2,width) && mouseY.between(height/4,height*3/4))) {
    viewStats = false;
  }

  if (viewStats && mouseX.between(width - statv + 10,width - statv + 10 + (width-100)/10) && mouseY.between(height/2,height*3/4) && money >= 8) {
    ph += round(10-demonskill/10);
    if (ph > mph) {ph = mph;}
    money -= 8;
  }
  if (viewStats && mouseX.between(width - statv + 15 + (width-100)/10,width - statv + (width-100)/10 + 15 + (width-100)/10) && mouseY.between(height/2,height*3/4) && money >=(demonskill+1)*5) {
    money -= (demonskill+1)*5;
    demonskill += 1;
    mph += 3;
    evilm += demonskill/10;
  }
  if (viewStats && mouseX.between(width - statv + 20 + (width-100)*2/10,width - statv + (width-100)*2/10 + 20 + (width-100)/10) && mouseY.between(height/2,height*3/4) && money >= (rskill)*6) {
    money -= (rskill)*6;
    rskill += 1;
  }
  if (viewStats && mouseX.between(width - statv + 25 + (width-100)*3/10,width - statv + (width-100)*3/10 + 25 + (width-100)/10) && mouseY.between(height/2,height*3/4) && evil < 100) {
    State = 2;
  }
  if (viewStats && mouseX.between(width - statv + 30 + (width-100)*4/10,width - statv + (width-100)*4/10 + 30 + (width-100)/10) && mouseY.between(height/2,height*3/4) && evil > 900) {
    State = 3;
  }
}

void drawKnight(x,y,a,b,c,d,e,f) {
  if (f) {
    scale(-1,1);
    tint(a);
    image(knight[0],-x,y);
    tint(255);
    image(knight[1],-x,y);
    if (d) {image(knight[4],-x,y);} else {image(knight[5],-x,y);}
    if (e) {image(knight[6],-x,y);}
    tint(b);
    image(knight[2],-x,y);
    tint(c);
    image(knight[3],-x,y);
    scale(-1,1);
  } else {
    tint(a);
    image(knight[0],x,y);
    tint(255);
    image(knight[1],x,y);
    if (d) {image(knight[4],x,y);} else {image(knight[5],x,y);}
    if (e) {image(knight[6],x,y);}
    tint(b);
    image(knight[2],x,y);
    tint(c);
    image(knight[3],x,y);
  }
}

void drawLost(x,y,a,b,c,d,e) {
  if (e) {
    scale(-1,1);
    tint(a);
    image(knight[0],-x,y);
    tint(255);
    image(knight[1],-x,y);
    image(lknight[2],-x,y);
    if (d) {image(lknight[3],-x,y);}
    tint(b);
    image(lknight[0],-x,y);
    tint(c);
    image(lknight[1],-x,y);
    scale(-1,1);
  } else {
    tint(a);
    image(knight[0],x,y);
    tint(255);
    image(knight[1],x,y);
    image(lknight[2],x,y);
    if (d) {image(lknight[3],x,y);}
    tint(b);
    image(lknight[0],x,y);
    tint(c);
    image(lknight[1],x,y);
  }
}

class Contact {
  String name;
  String order;
  float skill;
  float hp;
  float mhp;
  float dc;
  float trust = random(100);
  int speak = 0;
  int action = 0;
  color[] armor = new color[3];
  boolean hasHelm;
 
  Contact() {
    hasChallenger = true;
    armor[0] = color(0,0,255);
    name = chance.last();
    skill = abs(cskill + random(-5,10));
    if (skill > cskill) {cskill = skill;}
    if (skill < 5) {
      order = "Squire";
      textlines.add(new Textline("A figure steps into thy lair.",color(255,255,200)));
      armor[1] = color(255,0);
      armor[2] = color(255,0);
      hasHelm = false;
    } else if (skill < 20) {
      order = "Knight";
      textlines.add(new Textline("A helmeted figure steps into thy lair.",color(255,255,200)));
      armor[1] = color(255,0);
      armor[2] = color(255,0);
      hasHelm = true;
    } else if (skill < 35) {
      order = "Baronet";
      textlines.add(new Textline("A horseman rides into thy lair.",color(255,255,200)));
      armor[1] = color(random(150,255),random(150,255),random(150,255));
      armor[2] = color(random(150,255),random(150,255),random(150,255));
      hasHelm = false;
    } else if (skill < 50) {
      order = "Baron";
      textlines.add(new Textline("A skilled horseman rides into thy lair.",color(255,255,200)));
      armor[1] = color(random(150,255),random(150,255),random(150,255));
      armor[2] = color(random(150,255),random(150,255),random(150,255));
      hasHelm = true;
    } else if (skill < 65) {
      order = "Viscount";
      textlines.add(new Textline("Someone sneaks into thy lair.",color(255,255,200)));
      armor[1] = color(random(150,255),random(150,255),random(150,255));
      armor[2] = color(random(150,255),random(150,255),random(150,255));
      hasHelm = true;
    } else if (skill < 80) {
      order = "Earl";
      textlines.add(new Textline("A burly warrior breaks into thy lair.",color(255,255,200)));
      armor[1] = color(random(150,255),random(150,255),random(150,255));
      armor[2] = color(random(150,255),random(150,255),random(150,255));
      hasHelm = true;
    } else if (skill < 95) {
      order = "Marquess";
      textlines.add(new Textline("Someone with authority steps into thy lair.",color(255,255,200)));
      armor[1] = color(random(150,255),random(150,255),random(150,255));
      armor[2] = color(random(150,255),random(150,255),random(150,255));
      hasHelm = true;
    } else {
      order = "Viceroy";
      textlines.add(new Textline("Someone strong and dangerous steps into thy lair.",color(255,255,200)));
      armor[1] = color(random(150,255),random(150,255),random(150,255));
      armor[2] = color(random(150,255),random(150,255),random(150,255));
      hasHelm = true;
    }
    hp = ceil(random(skill+1));
    mhp = hp;
    dc = skill/(pskill+random(demonskill));
  }
  
  void update() {
    if (action != 4 && action != 2) {speak += 1;}
    if (speak == 80) {
      if (action == 5) {
        if (trust < 80) {
          textlines.add(new Textline(order + " " + name + " hath return'd with a vengeance!",color(255,150,150)));
          action = 1;
        } else {
          textlines.add(new Textline(order + " " + name + ": 'Ahh, greetings brother!'",color(255,255,255)));
          action = 1;
        }
      } else {
        if (trust < 30) {
          textlines.add(new Textline(order + " " + name + ": 'How dare thou bad-mouth the Duke!'",color(255,150,150)));
          action = 1;
        } else if (trust < 50) {
          textlines.add(new Textline(order + " " + name + ": 'For the Duke of Agraolind!'",color(255,150,150)));
          action = 1;
        } else if (trust < 80) {
          textlines.add(new Textline(order + " " + name + ": 'Don't take a single grise 'r i'll kill thou!'",color(255,170,170)));
          action = 1;
        } else {
          textlines.add(new Textline("It's thy cater-cousin, " + order + " " + name + ".",color(255,255,255)));
          action = 1;
        }
      }
    }
    if (action == 1) {
      if (speak == 100) {
        if (trust < 80) {textlines.add(new Textline(order + " " + name + " pulls out his blade.",color(255,150,150)));} else {
          textlines.add(new Textline(order + " " + name + ": Here's some chinks! Let's see how strong you've become.",color(255,255,255)));
          money += round(random(skill*1.5));
        }
      }
      if (speak >= 100) {
        textAlign(CENTER,BOTTOM);
        text((100 - round(dc*100)) + "/" + round(dc*100),width/2,height);
        text("Chances",width/2,height - 50);
        textAlign(LEFT,BOTTOM);
        text(ph + "/" + mph + " HP",0,height);
        textAlign(RIGHT,BOTTOM);
        text(hp + "/" + mhp + " HP",width,height);
        fdist += (((abs((speak%30 - 15)/15))*(width/2 - width/6)) - fdist)/4;
        drawKnight(width - width/6 - fdist,theight - knight[0].width,armor[0],armor[1],armor[2],false,hasHelm,false);
      } else {
        drawKnight(width - width/6,theight - knight[0].width,armor[0],armor[1],armor[2],true,hasHelm,false);
      }
      if (speak > 135 && speak%30 == 0) {
        if (random(1) > dc) {
          tools.add(new Tool(width - width/6 - fdist + knight[0].width/2));
          if (trust < 80) {hp -= round(random(pskill));}
            textlines.add(new Textline("Thou hit the " + order + " with a swing of thy blade. ",color(255,255,150)));
          if (random(1) > 0.9 || trust >= 80 || hp <= 0) {
            action = 2;
            if (trust < 40) {
              textlines.add(new Textline(order + " " + name + ": 'Prithee let me go!'",color(255,200,200)));
            } else if (trust < 80) {
              textlines.add(new Textline(order + " " + name + ": 'Ye are artful; mine fate is in thy hands.'",color(255,200,200)));
            } else {
              textlines.add(new Textline(order + " " + name + ": 'Thou hast got me! Ha!'",color(255,255,255)));
              action = 2;
            }
            killornot = true;
          }
        } else {
            tools.add(new Tool(width/6 + fdist - knight[0].width/2));
            if (trust < 80) {
              ph -= round(random(skill));
              restime = 500;
            }
        }
      }
    }
    if (action == 2) {
      drawLost(width - width/6 - (width/2 - width/6),theight - knight[0].width,armor[0],armor[1],armor[2],hasHelm,false);
    }
    if (action == 3) {
      
    }
  }
}

class Tool {
  float r;
  float h;
  float x;
 
  Tool(ox) {
    r = random(3);
    h = 25;
    x = ox;
  }
  
  void update() {
    h -= 1;
    tint(255,(h/25)*255);
    translate(x,theight-knight[0].width/2);
    rotate(r);
    image(sf,0 - sf.width/2,0 - sf.height/2);
    rotate(-r);
    translate(-x,-(theight-knight[0].width/2));
    tint(255);
  }
}

class Textline {
  String s;
  color c;
  float y;
 
  Textline(os,oc) {
    s = os;
    c = oc;
    if (textlines.size() >= 1) {
      Particle l = (Textline) textlines.get(textlines.size()-1);
      if (l.y + 70 >= theight - knight[0].width + 16) {
        for (int i=textlines.size()-1; i>=0; i--) {
          Particle ll = (Textline) textlines.get(i);
          ll.y -= 50;
        }
      }
      y = l.y + 50;
    } else {y = 0;}
  }
  
  void update() {
    textAlign(LEFT,CENTER);
    if (y + 45 >= theight - knight[0].width + 16) {fill(0);} else {fill(c);}
    text(s,0,y + 20);
  }
}