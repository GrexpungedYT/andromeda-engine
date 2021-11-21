package modchart.modifiers;
import ui.*;
import modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

class AlphaModifier extends Modifier {
  public static var fadeDistY = 120;

  public function getHiddenSudden(player:Int=-1){
    return getSubmodPercent("hidden",player) * getSubmodPercent("sudden",player);
  }

  public function getHiddenEnd(player:Int=-1){
    return modMgr.state.center.y + fadeDistY * CoolUtil.scale(getHiddenSudden(player),0,1,-1,-1.25) + modMgr.state.center.y * getSubmodPercent("hiddenOffset",player);
  }

  public function getHiddenStart(player:Int=-1){
    return modMgr.state.center.y + fadeDistY * CoolUtil.scale(getHiddenSudden(player),0,1,0,-0.25) + modMgr.state.center.y * getSubmodPercent("hiddenOffset",player);
  }

  public function getSuddenEnd(player:Int=-1){
    return modMgr.state.center.y + fadeDistY * CoolUtil.scale(getHiddenSudden(player),0,1,1,1.25) + modMgr.state.center.y * getSubmodPercent("suddenOffset",player);
  }

  public function getSuddenStart(player:Int=-1){
    return modMgr.state.center.y + fadeDistY * CoolUtil.scale(getHiddenSudden(player),0,1,0,0.25) + modMgr.state.center.y * getSubmodPercent("suddenOffset",player);
  }

  override function updateNote(pos:FlxPoint, scale:FlxPoint, note:Note){
    var player = note.mustPress==true?0:1;
    var yPos = pos.y;
    var distFromCenter = yPos - modMgr.state.center.y;
    var alpha:Float = 0;

    var time = Conductor.songPosition/1000;

    if(getSubmodPercent("hidden",player)!=0){
      var hiddenAdjust = CoolUtil.clamp(CoolUtil.scale(yPos,getHiddenStart(player),getHiddenEnd(player),0,-1),-1,0);
      alpha += getSubmodPercent("hidden",player)*hiddenAdjust;
    }

    if(getSubmodPercent("sudden",player)!=0){
      var suddenAdjust = CoolUtil.clamp(CoolUtil.scale(yPos,getSuddenStart(player),getSuddenEnd(player),0,-1),-1,0);
      alpha += getSubmodPercent("sudden",player)*suddenAdjust;
    }

    if(getPercent(player)!=0){
      alpha -= getPercent(player);
    }

    if(getSubmodPercent("blink",player)!=0){
      var f = CoolUtil.quantize(FlxMath.fastSin(time*10),0.3333);
      alpha += CoolUtil.scale(f,0,1,-1,0);
    }

    if(getSubmodPercent("randomVanish",player)!=0){
      var realFadeDist:Float = 240;
      alpha += CoolUtil.scale(Math.abs(distFromCenter),realFadeDist,2*realFadeDist,-1,0)*getSubmodPercent("randomVanish",player);
    }

    note.desiredAlpha=CoolUtil.clamp(alpha+1,0,1);

  }

  override function getSubmods(){
    var subMods:Array<String> = ["hidden","hiddenOffset","sudden","suddenOffset","blink","randomVanish"];
    return subMods;
  }
}