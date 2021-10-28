package modchart.modifiers;

import modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;

class DrunkModifier extends Modifier {
  override function getReceptorPos(receptor:Receptor, pos:FlxPoint, data:Int, player:Int){
    var drunkPerc = getPercent(player);
    var tipsyPerc = getSubmodPercent("tipsy",player);
    var tipsySpeed = CoolUtil.scale(getSubmodPercent("tipsySpeed",player),0,1,1,2);
    var drunkSpeed = CoolUtil.scale(getSubmodPercent("drunkSpeed",player),0,1,1,2);

    var time = Conductor.songPosition/1000;

    if(drunkPerc!=0){
      pos.x += drunkPerc * (FlxMath.fastCos((time + data*.2)*drunkSpeed) * Note.swagWidth*.5);
    }

    if(tipsyPerc!=0){
      pos.y += tipsyPerc * (FlxMath.fastCos((time*1.2 + data*1.8)*tipsySpeed) * Note.swagWidth*.4);
    }

    return pos;
  }

  override function getNotePos(note:Note, pos:FlxPoint, data:Int, player:Int){
    var drunkPerc = getPercent(player);
    var tipsyPerc = getSubmodPercent("tipsy",player);
    var drunkSpeed = CoolUtil.scale(getSubmodPercent("drunkSpeed",player),0,1,1,2);

    var receptors = modMgr.receptors[player];
    var time = Conductor.songPosition/1000;
    if(drunkPerc!=0){
      if(note.isSustainNote){
        if(note.prevNote!=null && !note.prevNote.wasGoodHit){
          if(note.prevNote.isSustainNote){
            pos.x = note.prevNote.x;
          }else{
            pos.x = note.prevNote.x + note.manualXOffset;
          }
        }else{
          pos.x = modMgr.state.getXPosition(note);
        }

      }else{
        pos.x = modMgr.state.getXPosition(note,false)+(drunkPerc*(FlxMath.fastCos((time + data*.2 + pos.y*10/FlxG.height)*drunkSpeed) * Note.swagWidth*.5));
      }

    }

    return pos;
  }

  override function getSubmods(){
    return ["tipsy","drunkSpeed","tipsySpeed"];
  }

}