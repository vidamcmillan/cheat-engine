unit bullet;

{$mode objfpc}{$H+}

interface

uses
  windows, Classes, SysUtils, gameobject, graphics, gl, glext, math, globals;

type
  TBullet=class(TGameObject)
  private
    instances2: integer; static;
    ftexture2: integer; static;
  protected
    function getWidth:single; override;
    function getHeight:single; override;
    function getTexture: integer; override;
  public
    speed: single; //distance / ms

    procedure travel(time: single);
    constructor create;
    destructor destroy; override;
  end;


implementation

procedure TBullet.travel(time:single);
var
  distance: single;
  d: single;
begin
  distance:=speed*time;

  x:=x+distance*sin(degtorad(rotation));
  y:=y+distance*-cos(degtorad(rotation));

  //todo, check for collision here instead

end;

function TBullet.getWidth:single;
begin
  result:=0.05; //fwidth;
end;

function TBullet.getHeight:single;
begin
  result:=0.05*1.6; //height
end;

function TBullet.getTexture: integer;
begin
  result:=ftexture2;
end;

constructor TBullet.create;
var img: tpicture;
  pp: pointer;
begin
  inherited create;

  speed:=0.001;
  if instances2=0 then
  begin
    glGenTextures(1, @ftexture2);

    img:=tpicture.Create;
    img.LoadFromFile(assetsfolder+'bullet.png');

    glBindTexture(GL_TEXTURE_2D, ftexture2);
    glActiveTexture(GL_TEXTURE0);

    //glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 2, 2, 0, GL_RGB, GL_FLOAT, @pixels[0]);

    pp:=img.BITMAP.RawImage.Data;

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, img.Width, img.height, 0, GL_BGRA,  GL_UNSIGNED_BYTE, pp);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    img.free;

  end;

  inc(instances2);
end;

destructor TBullet.destroy;
begin
  dec(instances2);
  if instances2=0 then //destroy the texture
    glDeleteTextures(1,@ftexture2);

  inherited destroy;
end;


end.

